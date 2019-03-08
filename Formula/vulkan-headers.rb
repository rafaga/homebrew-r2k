class VulkanHeaders < Formula
  desc "Provides header files and the Vulkan API definition (registry)"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers.git", :revision => "8e2c4cd554b644592a6d904f2c8000ebbd4aa77f"
  version "1.1.97"
  revision 1
  head "https://github.com/KhronosGroup/Vulkan-Headers.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  conflicts_with "homebrew/core/vulkan-headers"

  def install
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
