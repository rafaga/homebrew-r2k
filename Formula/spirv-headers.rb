class SpirvHeaders < Formula
  desc "Provides the header files for the Vulkan SPIR-V Registry"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers.git", :revision => "79b6681aadcb53c27d1052e5f8a0e82a981dbf2f"
  version "1.1-rc2-git79b6681aadcb"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Headers.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  def install
    args = std_cmake_args + [
      "-DSPIRV_HEADERS_SKIP_EXAMPLES=OFF",
    ]
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
