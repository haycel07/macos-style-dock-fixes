import fs from 'node:fs';
import path from 'node:path';
import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';
const here=path.dirname(fileURLToPath(import.meta.url));
const root=path.resolve(here,'..');
const app=process.env.WINDHAWK_DIR??path.join(process.env.LOCALAPPDATA,'Programs','Windhawk');
const compiler=path.join(app,'Compiler');
const output=path.join(root,'bin','macos-style-dock_1.0-local.4.dll');
const args=[
 '-std=c++23','-O2','-shared','-DUNICODE','-D_UNICODE',
 '-DWINVER=0x0A00','-D_WIN32_WINNT=0x0A00','-D_WIN32_IE=0x0A00','-DNTDDI_VERSION=0x0A000008',
 '-D__USE_MINGW_ANSI_STDIO=0','-DWH_MOD',
 '-DWH_MOD_ID=L"macos-style-dock"','-DWH_MOD_VERSION=L"1.0-local.4"',
 path.join(app,'Engine','1.7.3','64','windhawk.lib'),
 '-x','c++',path.join(root,'src','macos-style-dock.wh.cpp'),
 '-include','windhawk_api.h','-target','x86_64-w64-mingw32',
 '-Wl,--export-all-symbols','-o',output,
 '-lole32','-loleaut32','-lruntimeobject','-lversion','-lgdi32','-lshell32','-lshcore','-ladvapi32'
];
const run=spawnSync(path.join(compiler,'bin','clang++.exe'),args,{cwd:compiler,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});
fs.writeFileSync(path.join(root,'build.log'),`${run.stdout??''}\n${run.stderr??''}`);
console.log(JSON.stringify({exitCode:run.status,error:run.error?.message,output:run.status===0?output:undefined,stderr:run.stderr?.slice(-10000)},null,2));
process.exitCode=run.status??1;




