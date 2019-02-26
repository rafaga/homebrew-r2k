class SpirvHeaders < Formula
  desc "Provides the header files for the Vulkan SPIR-V Registry"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers.git", :commit => "79b6681aadcb53c27d1052e5f8a0e82a981dbf2f"
  version "1.1-rc2-git79b6681aadcb"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Headers.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = std_cmake_args + [
      "-DSPIRV_HEADERS_SKIP_EXAMPLES=ON",
    ]
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
    end

    # required for tests
    prefix.install "example"
    # (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"example/*"], testpath
    system "cmake", "-G", "Ninja", ".", *std_cmake_args
    system "ninja"
  end
end
