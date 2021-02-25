from genericpath import exists
import hashlib
import json
import logging
import os
import sys
from sys import path
import threading
import urllib

import click
import coloredlogs
import json5
import requests
import urllib3
from prettytable import PrettyTable

DEBUG_MODE = False
CONFIG_FILE = ""
MANIFEST_FILE = ""
CONFIG = {}
MANIFEST = {}


def readjson(config_file):
    try:
        with open(config_file, "r", encoding="utf-8") as f:
            return json5.load(f)
    except Exception as e:
        logging.error(f"无法读取文件, 文件不存在或有错误: {e}")
        exit(1)


def fsize(num: float = 0):
    units = ["B", "KiB", "MiB", "GiB", "TiB"]
    divisor = 1024

    def _fs(_num, _level, _divisor):
        if _level >= len(units)-1:
            return _num, _level
        elif _num >= _divisor:
            _num /= _divisor
            _level += 1
            return _fs(_num, _level, _divisor)
        else:
            return _num, _level
    num, level = _fs(num, 0, divisor)
    if level > len(units):
        level -= 1
    return f"{round(num, 2)} {units[level]}"


class Manifest(object):
    manifest = {}

    def __init__(self, manifest):
        self.manifest = manifest

    def mods(self):
        return self.manifest["files"]

    def _extend_thread(self, _count, _index, projectID, fileID):
        try:
            urllib3.disable_warnings()
            headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36"}
            r = requests.get(f"{CONFIG['curseforge']['apiurl']}{projectID}", headers=headers, verify=False, proxies=CONFIG["proxy"], timeout=5)
            r.raise_for_status()
            res_text = json.loads(r.text)
            self.manifest["files"][_index]["projectName"] = res_text["name"]
            r = requests.get(f"{CONFIG['curseforge']['apiurl']}{projectID}/file/{fileID}", headers=headers, verify=False, proxies=CONFIG["proxy"], timeout=5)
            r.raise_for_status()
            res_text = json.loads(r.text)
            self.manifest["files"][_index]["fileDate"] = res_text["fileDate"]
            self.manifest["files"][_index]["fileName"] = res_text["fileName"]
            self.manifest["files"][_index]["fileLength"] = res_text["fileLength"]

            self.manifest["files"][_index]["fileMD5"] = urllib.request.build_opener(urllib.request.ProxyHandler(CONFIG["proxy"])).open(urllib.parse.quote(res_text["downloadUrl"], safe='/:?=')).getheader(name="Etag").replace("\"", "")
        except Exception as e:
            logging.error(f"[{_index+1}/{_count}] 错误: {e}")
            logging.debug(e)

    def extend(self):
        _modlist = self.mods()
        _count = len(_modlist)
        thread_list = []
        print(f'\x1B[K 正在从CurseForge获取信息, 请稍后... \033[0m\r', end='')
        for index, item in enumerate(_modlist):
            try:
                t = threading.Thread(target=self._extend_thread, args=(_count, index, item["projectID"], item["fileID"]))
                thread_list.append(t)
            except Exception as e:
                logging.error(f"[{index+1}/{_count}] 错误: {e}")
                logging.debug(e)
                continue
        for t in thread_list:
            t.setDaemon(True)
            t.start()
        for t in thread_list:
            t.join()

    def info_table(self):
        _data = self.manifest
        info_tb = PrettyTable(["类别", "数据"])
        info_tb.title = "基本信息"
        info_tb.add_row(["名称", _data["name"]])
        info_tb.add_row(["版本", _data["version"]])
        info_tb.add_row(["作者", _data["author"]])
        print(info_tb)
        mc_tb = PrettyTable(["类别", "版本"])
        mc_tb.title = "游戏信息"
        mc_tb.add_row(["本体", _data["minecraft"]["version"]])
        mc_tb.add_row(["模组加载器", "↓"])
        for index, item in enumerate(_data["minecraft"]["modLoaders"]):
            mc_tb.add_row(["→", item["id"]])
        print(mc_tb)
        mods_tb = PrettyTable(["序号",  "类型", "项目名称", "项目ID", "文件ID", "文件名", "文件大小", "发布日期", "MD5"])
        mods_tb.title = "模组列表"
        for index, item in enumerate(self.mods()):
            mods_tb.add_row([
                index,
                (item["type"]) if "type" in item.keys() else "-",
                (item["projectName"]) if "projectName" in item.keys() else "-",
                item["projectID"], item["fileID"],
                (item["fileName"]) if "fileName" in item.keys() else "-",
                (fsize(item["fileLength"])) if "fileLength" in item.keys() else "-",
                (item["fileDate"]) if "fileDate" in item.keys() else "-",
                (item["fileMD5"]) if "fileMD5" in item.keys() else "-",
            ])
        print(mods_tb)


@click.group(invoke_without_command=False)
@click.option("--debug", is_flag=True, default=False, help="启用调试模式")
@click.option("--config", "config_file", default="config.json", help="指定配置文件,默认为config.json")
@click.option("--manifest", "manifest_file", default="manifest.json", help="指定CurseForge配置文件,默认为manifest.json")
# @click.option("--manifest", "manifest_file", default="../../server/minecraft/manifest.json")
# @click.option("--manifest", "manifest_file", default="manifest.test.json")
def cli(debug, config_file, manifest_file):
    global DEBUG_MODE
    global CONFIG
    global CONFIG_FILE
    global MANIFEST_FILE
    global MANIFEST
    # print(debug)
    fmt = "[%(asctime)s] %(filename)s[line:%(lineno)d] %(message)s"
    field_styles = {"asctime": {"color": "green"}, "hostname": {"color": "magenta"}, "levelname": {"color": "magenta"}, "filename": {"color": "magenta"}, "name": {"color": "blue"}, "threadName": {"color": "green"}}
    level_styles = {"debug": {"color": "white"}, "info": {"color": "cyan"}, "warning": {"color": "yellow"}, "error": {"color": "red"}, "critical": {"color": "red"}}
    level = logging.DEBUG if debug == True else logging.INFO
    if debug == True:
        logging.debug("\033[32m调试模式已开启\033[0m")
        DEBUG_MODE = True
    else:
        DEBUG_MODE = False
    coloredlogs.install(level=level, fmt=fmt, field_styles=field_styles, level_styles=level_styles)

    CONFIG_FILE = config_file
    CONFIG = readjson(config_file)
    MANIFEST_FILE = manifest_file
    MANIFEST = readjson(manifest_file)


@cli.command(help="从Manifest中获取信息")
# @ click.option("--markdown", "gen_md", is_flag=True, default=False, help="")
@ click.option("--extend", is_flag=True, default=False, help="从CurseForge获取更多信息, 若获取到的CF的信息与Manifest文件中的冲突则以CF的信息为准")
def info(extend):
    logging.debug(json.dumps(MANIFEST, ensure_ascii=False, indent=4))
    mObj = Manifest(MANIFEST)
    if extend == True:
        mObj.extend()
    mObj.info_table()


@cli.command(help="格式化Manifest文件")
@click.option("--sort-mods", "sortmods", is_flag=True, default=False, help="根据Mod的Project ID排序files列表")
@ click.option("--standardize", "standardize", is_flag=True, default=False, help="将文件还原为CurseForge的标准格式. 若未指定输出文件, 程序会自动创建备份文件. 覆盖其他选项的效果")
@ click.option("--extend-mod-info", "extendmod", is_flag=True, default=False, help="从CurseForge获取更多信息, 若获取到的CF的信息与Manifest文件中的冲突则以CF的信息为准")
@ click.option("--out", "-o", "_out", default="", help="输出文件, 若不指定则覆盖原文件")
def format(sortmods, standardize, extendmod, _out):
    if _out == "":
        out = MANIFEST_FILE
    else:
        out = _out
        logging.info(f"输出结果到 {os.path.abspath(out)}")
    mObj = Manifest(MANIFEST)
    if sortmods == True:
        logging.info("根据Mod的Project ID排序files列表")
        mObj.manifest["files"] = sorted(mObj.mods(), key=lambda i: i["projectID"])
    if standardize == True:
        logging.info("将文件还原为CurseForge的标准格式")
        if _out == "":
            with open(out+".bak", "w") as f:
                logging.info(f"创建备份文件 {os.path.abspath(out+'.bak')}")
                json.dump(mObj.manifest, f, ensure_ascii=False)
        mods = mObj.mods()
        for item in mods[:]:
            if "type" in item.keys():
                if item["type"] == 1:
                    mods.remove(item)
        for item in mods:
            item.pop("type", 0)
            item.pop("projectName", 0)
            item.pop("fileDate", 0)
            item.pop("fileName", 0)
            item.pop("fileLength", 0)
            item.pop("fileMD5", 0)
        mObj.manifest["files"] = mods
        with open(out, "w") as f:
            json.dump(mObj.manifest, f, ensure_ascii=False)
        return
    if extendmod == True:
        logging.info("从CurseForge获取更多信息")
        mObj.extend()
    with open(out, "w") as f:
        json.dump(mObj.manifest, f, ensure_ascii=False)


@ cli.command(help="根据Manifest的信息下载Mod")
@ click.option("--download-dir", "-D", "download", default="", help="下载文件的路径, 默认为本程序所在文件夹")
@ click.option("--no-check", "no_check", is_flag=True, default=False, help="禁用下载完成后Hash校验")
@ click.option("--overwrite", is_flag=True, default=False, help="覆盖同名文件, 不添加此选项则默认跳过同名文件")
@ click.option("--type", "_type", default=0, help="Mod类型, 0:忽略,1:仅服务端,2:仅客户端,3:双端,4:1+3,5:2+3")
# @ click.option("--no-async", "no_async", is_flag=True, default=False, help="")
@ click.option("--no-multithreading", "no_multithreading", is_flag=True, default=False, help="禁用多线程下载")
def dlmod(download, no_check, overwrite, _type, no_multithreading):
    if no_check == True:
        logging.info("命令行参数指定不进行Hash校验")
    if no_multithreading == True:
        logging.info("命令行参数指定禁用多线程下载")

    if os.path.exists(download):
        dpath = os.path.abspath(download)
    else:
        dpath = os.path.abspath(os.path.dirname(sys.argv[0]))
        logging.warning("指定的路径不可用或未指定路径,自动选择默认路径. 是否继续? [y/n]")
        c = click.getchar()
        click.echo()
        if c == 'y':
            pass
        elif c == 'n':
            exit()
        else:
            exit()

    mod_list = Manifest(MANIFEST).mods()
    mod_count = len(mod_list)
    logging.info(f"共找到 {mod_count} 个Mod, 开始下载任务")

    def dl_thread(_count, _index, projectID, fileID, _savedir, _overwrite):
        try:
            urllib3.disable_warnings()
            headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36"}

            r = requests.get(
                f"{CONFIG['curseforge']['apiurl']}{projectID}/file/{fileID}",
                headers=headers, verify=False, proxies=CONFIG["proxy"], timeout=5
            )
            r.raise_for_status()
            res_text = json.loads(r.text)
            download_url = res_text["downloadUrl"]
            file_name = res_text["fileName"]

            down_res = requests.get(download_url, headers=headers, proxies=CONFIG["proxy"], verify=False, timeout=120)
            down_res.raise_for_status()
            md5 = down_res.headers.get("ETag").replace("\"", "")

            _file_path = f"{_savedir}\{file_name}"
            if os.path.exists(_file_path):
                logging.warning(f"[{_index}/{_count}] {file_name} 文件已存在 -> {('跳过') if _overwrite == False else ('覆盖')}")
                if _overwrite == False:
                    return
            with open(_file_path, "wb") as f:
                f.write(down_res.content)
            logging.info(f"[{_index}/{_count}] {file_name} 下载完成")

            if no_check == False:
                with open(_file_path, "rb") as f:
                    md5Obj = hashlib.md5()
                    md5Obj.update(f.read())
                    _cmd5 = md5Obj.hexdigest().upper().lower()
                    logging.debug(_cmd5+" -> "+md5)
                    if _cmd5 != md5:
                        logging.error(f"[{_index}/{_count}] {file_name} 校验失败: {_cmd5} != {md5}")
        except Exception as e:
            logging.error(f"[{_index}/{_count}] 错误: {e}")
            logging.debug(e)

    thread_list = []
    for index, item in enumerate(mod_list):
        index = index + 1
        if _type != 0:
            if "type" in item.keys():
                if _type == 4:
                    if item["type"] == 2:
                        logging.info(f"[{index}/{mod_count}] {item['projectID']}:{item['fileID']} 为仅客户端Mod -> 跳过")
                        continue
                elif _type == 5:
                    if item["type"] == 1:
                        logging.info(f"[{index}/{mod_count}] {item['projectID']}:{item['fileID']} 为仅服务端Mod -> 跳过")
                        continue
                elif _type != item["type"]:
                    logging.info(f"[{index}/{mod_count}] {item['projectID']}:{item['fileID']} 与命令行指定的类型不符 -> 跳过")
                    continue
                else:
                    pass
        try:
            if no_multithreading == False:
                t = threading.Thread(target=dl_thread, args=(mod_count, index, item["projectID"], item["fileID"], dpath, overwrite))
                thread_list.append(t)
            else:
                dl_thread(mod_count, index, item["projectID"], item["fileID"], dpath, overwrite)
        except Exception as e:
            logging.error(f"[{index}/{mod_count}] 错误: {e}")
            logging.debug(e)
            continue

    if no_multithreading == False:
        for t in thread_list:
            t.setDaemon(True)
            t.start()
        for t in thread_list:
            t.join()


if __name__ == "__main__":
    click.clear()
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))
    cli()
