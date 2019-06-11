$pkg_name="tomcat8"
$pkg_origin="winhab"
$pkg_version="8.5.41"
$pkg_description="An open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies."
$pkg_upstream_url="https://tomcat.apache.org/"
$pkg_license=@("Apache 2.0")
$pkg_deps=@("winhab/corretto8")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="http://apache.spinellicreations.com/tomcat/tomcat-8/v$pkg_version/bin/apache-tomcat-$pkg_version-windows-x64.zip"
$pkg_shasum="117230aac76ecc1e9d04aff4e312dd9ff9ccb20d6246d0eef8199eec073f9778"
$pkg_dirname="apache-tomcat-$pkg_version"
$pkg_exports=@{
    "port" = "server.port"
}
$pkg_exposes=@("port")


function Invoke-Before{
    If (Test-Path -Path hooks.win\run ) {Remove-Item -path hooks; Rename-Item -path hooks.win -NewName hooks} Else {"Windows files are prepared for use"}
}
 function Invoke-Build {
     $env:JAVA_HOME = {{pkgPathFor "winhab/corretto"}} 
 }

function Invoke-Install {
    Write-BuildLine "Performing install"
    New-Item -ItemType Directory -Path "${pkg_prefix}/tc"
    Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/*" "$pkg_prefix/" -Recurse -Force -Verbose
    Start-Process "$env:TOMCAT_HOME\bin\service.bat install tomcat"
    
}

# function Invoke-Check {
#   (& "$pkg_prefix/tc/bin/tomcat8.exe" --version).StartsWith("tomcat8 $pkg_version")
# }
