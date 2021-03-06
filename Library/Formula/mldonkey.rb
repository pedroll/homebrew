require 'formula'

class Mldonkey < Formula
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  url 'https://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.3/mldonkey-3.1.3.tar.bz2'
  sha1 '424386f277e84df55a2cbab213fae60787e42c8b'

  option "with-x", "Build mldonkey with X11 support"

  depends_on 'pkg-config' => :build
  depends_on 'objective-caml'
  depends_on 'gd'
  depends_on :libpng

  if build.with? "x"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  # Fix gd detection, there are various upstream tickets referencing this
  patch :p0 do
    url "https://trac.macports.org/export/113436/trunk/dports/net/mldonkey/files/patch-config-configure.diff"
    sha1 "4c2fb3f8337f12533a03940834c1fb4bd7eaa9bf"
  end

  def install
    # Fix compiler selection
    ENV['OCAMLC'] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if build.with? "x"

    system "./configure", *args
    system "make install"
  end
end
