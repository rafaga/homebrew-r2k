class SpirvCross < Formula
  desc "Tool for parsing and converting SPIR-V to other shader language"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross.git", :revision => "3b366db7f1eed21c31b275f9f7b119d7b00c1b2a"
  version "0.35.0"
  revision 2
  head "https://github.com/KhronosGroup/SPIRV-Cross.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  #depends_on "rafaga/r2k/spirv-headers" => :build
  conflicts_with "homebrew/core/spirv-cross"

  def install
    mkdir "build" do
      args = std_cmake_args + [
        "-DSPIRV_CROSS_SANITIZE_THREADS=ON",
        "-DSPIRV_CROSS_SANITIZE_UNDEFINED=ON",
        "-DSPIRV_CROSS_STATIC=ON",
        "-DSPIRV_CROSS_SHARED=ON",
        "-DSPIRV_CROSS_CLI=ON",
      ]

      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
