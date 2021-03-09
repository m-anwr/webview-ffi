require "mkmf"
require "rbconfig"
abort("ERROR: OS not supported yet!")      unless RbConfig::CONFIG["host_os"] =~ /linux|cygwin/
abort("ERROR: gtk+-3.0 is missing.")       unless have_library("gtk-3")
abort("ERORR: webkit2gtk-4.0 is missing.") unless have_library("webkit2gtk-4.0")
pkg_config("--cflags --libs gtk+-3.0 webkit2gtk-4.0")
create_header
create_makefile 'webview/webview'