class Glslang < Formula
  desc "OpenGL and OpenGL ES shader front end and validator"
  homepage "https://github.com/KhronosGroup/glslang"
  url "https://github.com/KhronosGroup/glslang.git", :revision => "5432f0dd8f331f15182681664d7486681e8514e6"
  version "7.11.3113"
  revision 1
  head "https://github.com/KhronosGroup/glslang.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "rafaga/r2k/spirv-headers" => :build
  depends_on "rafaga/r2k/spirv-tools"
  conflicts_with "homebrew/core/glslang"

  patch do
    url "https://raw.githubusercontent.com/rafaga/homebrew-r2k/master/Patches/glslang/0001-enable-compatibility-with-pkg-config-utility.patch"
    sha256 "1630375d6df161ea6bb14095bcf46d82713bf66cb82be0808104dffded24e2e9"
  end

  patch do
    url "https://raw.githubusercontent.com/rafaga/homebrew-r2k/master/Patches/glslang/0002-Add-support-for-system-wide-dependencies-using-pkg-c.patch"
    sha256 "29cae2d28171a8185cef4a09cbc8e935b7d25b1108042cefe58a500101a81bd7"
  end

  patch do
    url "https://raw.githubusercontent.com/rafaga/homebrew-r2k/master/Patches/glslang/0003-refining-and-optimizing-some-cmake-script.patch"
    sha256 "f80ac50b5e13cc5e7103d3fa389cecfe0e74bb39d3d8981807da62aea86baaa7"
  end

  patch :DATA

  def install
    # Disabling Tests for now
    args = std_cmake_args + [
      "-DBUILD_SHARED_LIBS=OFF",
      "-DENABLE_GLSLANG_BINARIES=ON",
    ]

    inreplace Dir["#{buildpath}/CMakeLists.txt"].each do |s|
      s.gsub! "pkg_check_modules(SPIRV_TOOLS REQUIRED SPIRV-Tools>=2019.2.1)", \
          "pkg_check_modules(SPIRV_TOOLS REQUIRED SPIRV-Tools>=2019.2.0)"
      s.gsub! "pkg_check_modules(SPIRV_TOOLS_SHARED REQUIRED SPIRV-Tools>=2019.2.1)", \
          "pkg_check_modules(SPIRV_TOOLS_SHARED REQUIRED SPIRV-Tools>=2019.2.0)"
    end

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "false"
  end
end
