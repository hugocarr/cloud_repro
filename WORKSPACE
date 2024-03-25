workspace(name = "cloud_repro")

###################
## Load git_repository and http_archive
###################
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "platforms",
    sha256 = "8150406605389ececb6da07cbcb509d5637a3ab9a24bc69b1101531367d89d74",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.8/platforms-0.0.8.tar.gz",
        "https://github.com/bazelbuild/platforms/releases/download/0.0.8/platforms-0.0.8.tar.gz",
    ],
)

load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")

py_repositories()

python_register_toolchains(
    name = "python3_11",
    # Available versions are listed in @rules_python//python:versions.bzl.
    # We recommend using the same version your team is already standardized on.
    python_version = "3.11",
)

load("@python3_11//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "package_annotation", "pip_parse")

# This is a really gross workaround for name collisions in aws-cdk-lib
# Explanation of the problem: https://flyzipline.slack.com/archives/C061Z9HT6RH/p1701103197633249
# Source for the workaround: https://github.com/aws/jsii/issues/3881#issuecomment-1349684608
#
# Important notes:
# 1. We can't reference aws-cdk-lib using a requirement(...) call like every other Python
#    dependency. Instead, you need to reference them like this:
#    @workspace_python_deps_<name of package>//:wheel
# 2. For aws-cdk-lib, the package we need to import to have a working CDK script is inexplicably
#    aws-cdk-lambda-layer-kubectl-v23 rather than aws-cdk-lib.
#
# To aid in both of those things, there is an alias defined in the top-level BUILD file as
# `//:aws_cdk_lib` to make this a bit less horrific for end users.
#
# Phew!

PY_WHEEL_RULE_CONTENT = """\
load("@aspect_rules_py//py:defs.bzl", "py_wheel")
py_wheel(
    name = "wheel",
    src = ":whl",
)
"""

PACKAGES = [
    "aws-cdk-lambda-layer-kubectl-v23",
]

ANNOTATIONS = {
    pkg: package_annotation(additive_build_content = PY_WHEEL_RULE_CONTENT)
    for pkg in PACKAGES
}
# End really gross workaround for name collisions in aws-cdk-lib

pip_parse(
    name = "workspace_python_deps",
    annotations = ANNOTATIONS,

    # Begin workaround for aws-cdk-lib
    # https://github.com/aws/jsii/issues/3881#issuecomment-1349684608
    enable_implicit_namespace_pkgs = True,
    # (Optional) You can provide extra parameters to pip.
    # Here, make pip output verbose (this is usable with `quiet = False`).
    extra_pip_args = [
        "--find-links=https://pypi.python.org/simple",
    ],

    # (Optional) You can exclude custom elements in the data section of the generated BUILD files for pip packages.
    # Exclude directories with spaces in their names in this example (avoids build errors if there are such directories).
    #pip_data_exclude = ["**/* */**"],

    # (Optional) You can provide a python_interpreter (path) or a python_interpreter_target (a Bazel target, that
    # acts as an executable). The latter can be anything that could be used as Python interpreter. E.g.:
    # 1. Python interpreter that you compile in the build file (as above in @python_interpreter).
    # 2. Pre-compiled python interpreter included with http_archive
    # 3. Wrapper script, like in the autodetecting python toolchain.
    #
    # Here, we use the interpreter variable defined above to resolve to the more hermetic python
    # installed for bazel specifically
    python_interpreter_target = interpreter,

    # (Optional) You can set quiet to False if you want to see pip output.
    # quiet = False,

    # (Optional) You can set an environment in the pip process to control its
    # behavior. Note that pip is run in "isolated" mode so no PIP_<VAR>_<NAME>
    # style env vars are read, but env vars that control requests and urllib3
    # can be passed.
    #environment = {"HTTP_PROXY": "http://my.proxy.fun/"},
    requirements_lock = "//:requirements.txt",
    # End workaround for aws-cdk-lib
)

# # Initialize repositories for all packages in requirements.txt.
load("@workspace_python_deps//:requirements.bzl", "install_deps")

# NOTE: - this call is a lazy-load enforcement of the dependencies.
# This does NOT install libraries - it creates the repositories in the build-dir
# which allows you to depend on them using requirements() calls
install_deps()

# # End of in-build Python interpreter setup.
