class SpirvCross < Formula
  desc "Tool for parsing and converting SPIR-V to other shader language"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross.git", :commit => "d9ed3dcc7a7e62e5f95fd8f24e3d35e7e402ae92"
  version "2019-02-20"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Cross.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rafaga/r2k/spirv-headers" => :build
  conflicts_with "homebrew/core/spirv-cross"

  def install
    pc_file_name = "#{buildpath}/spirv-cross.pc.cmake.in"

    inreplace Dir["#{buildpath}/CMakeLists.txt"].each do |s|
      s.gsub! "enable_testing()", \
              "enable_testing()\n" \
              "include(GNUInstallDirs)"
      s.gsub! "target_link_libraries(spirv-cross-cpp spirv-cross-glsl)", \
              "target_link_libraries(spirv-cross-cpp spirv-cross-glsl)\n\n" \
              "configure_file(" \
              "${CMAKE_CURRENT_SOURCE_DIR}/spirv-cross.pc.cmake.in " \
              "${CMAKE_CURRENT_BINARY_DIR}/spirv-cross.pc " \
              "@ONLY)\n" \
              "install(" \
              "FILES ${CMAKE_CURRENT_BINARY_DIR}/spirv-cross.pc " \
              "DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig" \
              ")"
    end

    mkdir "build" do
      File.write(pc_file_name, pc_file)
      system "cmake", "-G", "Ninja", "..", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  def pc_file; <<~EOS
    prefix=@CMAKE_INSTALL_PREFIX@
    exec_prefix=@CMAKE_INSTALL_PREFIX@
    libdir=${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@
    \nName: @PROJECT_NAME@
    Description: Tool for parsing and converting SPIR-V to other shader language
    Requires:
    Version: 2019-02-20
    Libs: -L${libdir} -lspirv-cross-core -lspirv-cross-cpp -lspirv-cross-glsl -lspirv-cross-hlsl -lspirv-cross-msl -lspirv-cross-reflect -lspirv-cross-util
    Cflags: -I${includedir}
  EOS
  end

  test do
    system "false"
  end
end
