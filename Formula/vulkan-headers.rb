class VulkanHeaders < Formula
  desc "Provides header files and the Vulkan API definition (registry)"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers.git", :commit => "c200cb25db0f47364d3318d92c1d8e9dfff2fef1"
  version "1.1.97"
  revision 1
  head "https://github.com/KhronosGroup/Vulkan-Headers.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
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
