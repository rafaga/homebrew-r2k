class SpirvTools < Formula
  desc "Provides an API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools.git", :revision => "e128ab0d624ce7beb08eb9656bb260c597a46d0a"
  version "2020.3"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git"

  depends_on "cmake" => :build
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
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
