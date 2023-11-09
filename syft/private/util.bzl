def _maybe_wrap_launcher_for_windows(ctx, bash_launcher):
    """Windows cannot directly execute a shell script.

    Wrap with a .bat file that executes the shell script with a bash command.
    Based on create_windows_native_launcher_script from
    https://github.com/aspect-build/bazel-lib/blob/main/lib/windows_utils.bzl
    but without requiring that the script has a .runfiles folder.

    To use:
    - add the _windows_constraint appears in the rule attrs
    - make sure the bash_launcher is in the inputs to the action
    - @bazel_tools//tools/sh:toolchain_type should appear in the rules toolchains
    """
    if not ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        return bash_launcher

    win_launcher = ctx.actions.declare_file("wrap_%s.bat" % ctx.label.name)
    ctx.actions.write(
        output = win_launcher,
        content = r"""@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
for %%a in ("{bash_bin}") do set "bash_bin_dir=%%~dpa"
set PATH=%bash_bin_dir%;%PATH%
set args=%*
rem Escape \ and * in args before passing it with double quote
if defined args (
  set args=!args:\=\\\\!
  set args=!args:"=\"!
)
"{bash_bin}" -c "{launcher} !args!"
""".format(
            bash_bin = ctx.toolchains["@bazel_tools//tools/sh:toolchain_type"].path,
            launcher = bash_launcher.path,
        ),
        is_executable = True,
    )

    return win_launcher
