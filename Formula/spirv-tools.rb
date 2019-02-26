class SpirvTools < Formula
  desc "Provides an API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools.git", :commit => "117a1fd11f11e9bef9faa563c3d5156cc6ab529c"
  version "2019.1-git117a1fd11e9b"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rafaga/r2k/spirv-headers"

  def install
    # Disabling Tests for now
    args = std_cmake_args + [
      "-DSPIRV_BUILD_COMPRESSION=ON",
      "-DSPIRV_SKIP_TESTS=ON",
    ]

    inreplace Dir["#{buildpath}/CMakeLists.txt"].each do |s|
      s.gsub! "add_subdirectory(external)",
              "# add_subdirectory(external)\n" \
              "set(SPIRV_HEADER_DIR #{Formula["rafaga/r2k/spirv-headers"].opt_include})\n" \
              "set(SPIRV_HEADER_INCLUDE_DIR #{Formula["rafaga/r2k/spirv-headers"].opt_include})"
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
