class VulkanTools < Formula
  desc "Tools and utilities to verify use of Vulkan API on Applications"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://github.com/KhronosGroup/Vulkan-Tools.git", :commit => "ff56a741b1cce8ae20ff6276f51100e668e9c4f5"
  version "moltenvk-1.0.32"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build

  resource "MoltenVK" do
    url "https://github.com/KhronosGroup/MoltenVK.git", :tag => "v1.0.32"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"external"/resource.name
    end
    args = std_cmake_args + [
      "-DBUILD_CUBE=OFF",
      "-DBUILD_VULKANINFO=ON",
      "-DMOLTENVK_REPO_ROOT=#{prefix}/external/",
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
