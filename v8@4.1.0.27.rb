# Latest version supported by plv8.
class V8AT41027 < Formula
  homepage "https://code.google.com/p/v8/"
  url "https://github.com/v8/v8-git-mirror/archive/4.1.0.27.tar.gz"
  sha256 "04dde55ccd3e869e8aeeb511fdcaf6a339a67618884b0093550e80a04954862e"

  bottle do
    cellar :any
    sha256 "7f5e861ab2d85d9a01e0d1d51400fb94456fe8740c3815261ebdcfe3474bd023" => :yosemite
    sha256 "26282a8ec4d96166f1381ffeb48d7954965665ed7134339884cefda325c1aa45" => :mavericks
    sha256 "a9d8ff48bf5a34d7f39c3e6b4af4a3146518f6d5d45359bf95274574b080893e" => :mountain_lion
  end

  option "with-readline", "Use readline instead of libedit"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on "readline" => :optional

  # Update from "DEPS" file in tarball.
  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "fe00999dfaee449d3465a9316778434884da4fa7"
    version "2010"
  end

  resource "gmock" do
    url "http://googlemock.googlecode.com/svn/trunk", :revision => 501
    version "501"
  end

  resource "gtest" do
    url "http://googletest.googlecode.com/svn/trunk", :revision => 700
    version "700"
  end

  def install
    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    # Download gyp ourselves because running "make dependencies" pulls in ICU.
    (buildpath/"build/gyp").install resource("gyp")
    (buildpath/"testing/gmock").install resource("gmock")
    (buildpath/"testing/gtest").install resource("gtest")

    system "make", "native", "library=shared", "snapshot=on",
                   "console=readline", "i18nsupport=off"

    prefix.install "include"

    cd "out/native" do
      rm ["libgmock.a", "libgtest.a"]
      lib.install Dir["lib*"]
      bin.install "d8", "mksnapshot", "process", "shell" => "v8"
    end
  end
end
