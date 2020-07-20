class SpirvHeaders < Formula
  desc "Provides the header files for the Vulkan SPIR-V Registry"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers.git", :revision => "ac638f1815425403e946d0ab78bac71d2bdbf3be"
  version "1.5.3"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Headers.git"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + [
      "-DSPIRV_HEADERS_SKIP_EXAMPLES=OFF",
    ]
    mkdir "build" do
      system "cmake", *args,  ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
