#!powershell

#this file is part of Ansible
#Copyright © 2015 Sam Liu <sam.liu@activenetwork.com>

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

# WAIT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;

$result = New-Object psobject @{
    win_file_version = New-Object psobject
    changed = $false
}


If ($params.path) {
    $path = $params.path.ToString()
    If (-Not (Test-Path -Path $path -PathType Leaf)){
        Fail-Json $result "Specfied path: $path not exists or not a file"
    }
    $ext = [System.IO.Path]::GetExtension($path)
    If ( $ext -notin '.exe', '.dll'){
        Fail-Json $result "Specfied path: $path is not a vaild file type, Must be DLL or EXE."
    }
}
Else{
    Fail-Json $result "Specfied path: $path not define."
}

Try {
    $file_version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileVersion
    If ($file_version -eq $null){
        $file_version = ''
    }
    $product_version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).ProductVersion
    If ($product_version -eq $null){
        $product_version= ''
    }
    $file_major_part = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileMajorPart
    If ($file_major_part -eq $null){
        $file_major_part= ''
    }
    $file_minor_part = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileMinorPart
    If ($file_minor_part -eq $null){
        $file_minor_part= ''
    }
    $file_build_part = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileBuildPart
    If ($file_build_part -eq $null){
        $file_build_part = ''
    }
    $file_private_part = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FilePrivatePart
    If ($file_private_part -eq $null){
        $file_private_part = ''
    }
}
Catch{
}

Set-Attr $result.win_file_version "path" $path.toString()
Set-Attr $result.win_file_version "file_version" $file_version.toString()
Set-Attr $result.win_file_version "product_version" $product_version.toString()
Set-Attr $result.win_file_version "file_major_part" $file_major_part.toString()
Set-Attr $result.win_file_version "file_minor_part" $file_minor_part.toString()
Set-Attr $result.win_file_version "file_build_part" $file_build_part.toString()
Set-Attr $result.win_file_version "file_private_part" $file_private_part.toString()
Exit-Json $result;

