class VulkanPortability < Formula
  desc "Header files and spec for the Vulkan Portability extension"
  homepage "https://github.com/KhronosGroup/Vulkan-Portability"
  url "https://github.com/KhronosGroup/Vulkan-Portability.git", :revision => "53be040f04ce55463d0e5b25fd132f45f003e903"
  version "0.2"
  revision 1
  head "https://github.com/KhronosGroup/Vulkan-Portability.git"

  depends_on "cmake" => :build
  depends_on "rafaga/r2k/vulkan-headers"

  def install
    (include/"vulkan").install "include/vulkan/vk_extx_portability_subset.h"
    doc.install Dir["doc/specs/*"]
  end

  test do
    system "false"
  end
end
