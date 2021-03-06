class VulkanTools < Formula
  desc "Tools and utilities to verify use of Vulkan API on Applications"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://github.com/KhronosGroup/Vulkan-Tools.git", :commit => "ff56a741b1cce8ae20ff6276f51100e668e9c4f5"
  version "1.1.97"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build
  depends_on "rafaga/r2k/moltenvk"

  def install

    args = std_cmake_args + [
      "-DBUILD_CUBE=ON",
      "-DBUILD_VULKANINFO=ON",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["rafaga/r2k/vulkan-headers"].opt_prefix}",
      "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["rafaga/r2k/vulkan-loader"].opt_prefix}",
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
