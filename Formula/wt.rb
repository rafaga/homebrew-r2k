class Wt < Formula
  desc "Wt is a web GUI library in modern C++."
  homepage "https://www.webtoolkit.eu/wt"
  url "https://github.com/emweb/wt.git", :tag => "4.3.1"
  revision 1
  version "4.3.1"
  head "https://github.com/emweb/wt.git"

  depends_on "cmake" => :build
  depends_on "GraphicsMagick" => :recomended
  depends_on "OpenSSL" => :recomended
  depends_on "libharu" => :recomended
  depends_on "pango" => :recomended
  depends_on "qt5" => :recomended
  depends_on "zlib"
  depends_on "fcgi" => :recomended

  def install
    args = std_cmake_args + [
      "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick",
      "-DGM_PREFIX=#{Formula["GraphicsMagick"].opt_include}",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
  end
end
