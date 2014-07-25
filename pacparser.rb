require "formula"

class Pacparser < Formula
  homepage "https://code.google.com/p/pacparser/"
  url "https://pacparser.googlecode.com/files/pacparser-1.3.1.tar.gz"
  sha1 "eeaf890fddc16994d6063efe27a41488fa7f7ed9"

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.without?("python") && build.without?("python3")
    odie "You must build with python and/or python3 support."
  end

  def install
    Language::Python.each_python(build) do |python, version|
      ENV["PYTHON"] = python
      ENV["PREFIX"] = prefix
      ENV["EXTRA_ARGS"] = "--prefix=#{prefix}" # Used by setup.py

      system "make", "-C", "src", "clean"

      system "make", "-C", "src"
      system "make", "-C", "src", "install"

      system "make", "-C", "src", "pymod"
      system "make", "-C", "src", "install-pymod"
    end
  end

  test do
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import pacparser"
    end
  end
end
