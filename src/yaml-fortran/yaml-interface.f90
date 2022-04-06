module YAMLInterface

  use iso_c_binding

  implicit none

  private

  public :: c_yaml_destroy_domain
  public :: c_yaml_destroy_sequence
  public :: c_yaml_destroy_map
  public :: c_yaml_start_from_sequence
  public :: c_yaml_start_from_map
  public :: c_yaml_load_file
  public :: c_yaml_get_map_from_sequence
  public :: c_yaml_get_sequence_size
  public :: c_yaml_destroy_field
  public :: c_yaml_get_field
  public :: c_yaml_get_map_size  ! new name
  public :: c_yaml_get_map_label
  public :: c_yaml_get_map_from_field
  public :: strlen ! c standard library function

  public :: YAML_STRING
  public :: YAML_INT
  public :: YAML_INT_1D
  public :: YAML_INT_2D
  public :: YAML_DOUBLE
  public :: YAML_DOUBLE_1D
  public :: YAML_DOUBLE_2D
  public :: YAML_SEQUENCE
  public :: YAML_MAP


  enum, bind(c)  ! CTypesEnum
    enumerator :: YAML_INT_2D = 0
    enumerator :: YAML_DOUBLE_2D = 1
    enumerator :: YAML_INT_1D = 2
    enumerator :: YAML_DOUBLE_1D = 3
    enumerator :: YAML_INT = 4
    enumerator :: YAML_DOUBLE = 5
    enumerator :: YAML_STRING = 6
    enumerator :: YAML_SEQUENCE = 7
    enumerator :: YAML_MAP = 8
    enumerator :: INVALID = 9
  end enum


  interface


    function c_yaml_load_file(FilePath) result(Domain)  &
    bind(C, name="load_file")
      import
      type(c_ptr) :: Domain
      type(c_ptr), value :: FilePath
    end function c_yaml_load_file


    function c_yaml_start_from_sequence(Domain, Label) result (Seq) &
    bind(C, name="start_from_sequence")
      import
      type(c_ptr) :: Seq
      type(c_ptr), value :: Domain
      type(c_ptr), value :: Label
    end function c_yaml_start_from_sequence


    function c_yaml_start_from_map(Domain, Key) result (Seq) &
    bind(C, name="start_from_map")
      import
      type(c_ptr) :: Seq
      type(c_ptr), value :: Domain
      type(c_ptr), value :: Key
    end function c_yaml_start_from_map

    subroutine c_yaml_destroy_domain(Domain) &
    bind(C, name="destroy_domain")
      import
      type(c_ptr), value :: Domain
    end subroutine c_yaml_destroy_domain


    subroutine c_yaml_destroy_field(field) &
    bind(C, name="destroy_field")
      import
      type(c_ptr), value :: field
    end subroutine c_yaml_destroy_field


    subroutine c_yaml_destroy_sequence(seq) &
    bind(C, name="destroy_sequence")
      import
      type(c_ptr), value :: seq
    end subroutine c_yaml_destroy_sequence


    subroutine c_yaml_destroy_map(mapper) &
    bind(C, name="destroy_map")
      import
      type(c_ptr), value :: mapper
    end subroutine c_yaml_destroy_map


    function c_yaml_get_map_from_sequence(Seq, Idx) result (Vec) &
    bind(C, name="get_map_from_sequence")
      import
      type(c_ptr) :: Vec
      type(c_ptr), value :: Seq
      integer(c_int), value :: Idx
    end function c_yaml_get_map_from_sequence


    function c_yaml_get_sequence_size(Seq) result (N) &
    bind(C, name="get_sequence_size")
      import
      integer(c_int) :: N
      type(c_ptr), value :: Seq
    end function c_yaml_get_sequence_size


    function c_yaml_get_field(Vec, Label) result(Property) &
      bind(C, name="get_field")
      import
      type(c_ptr) , value :: Vec
      type(c_ptr), value :: Label
      type(c_ptr) :: property
      end function c_yaml_get_field


    function c_yaml_get_map_from_field(Element) result(List) &
      bind(C, name="get_map_from_field")
      import
      type(c_ptr), value :: Element
      type(c_ptr) :: List
      end function c_yaml_get_map_from_field

    function c_yaml_get_map_size(Element) result(N) &
      bind(C, name="get_map_size")
      import
      type(c_ptr), value :: Element
      integer(c_int) :: N
      end function c_yaml_get_map_size


    function strlen(ptr) result(N) &
      bind(C, name="strlen")
      import
      type(c_ptr), value :: ptr
      integer(c_int) :: N
      end function strlen


    function c_yaml_get_map_label(Element, idx) result(ptr) &
      bind(C, name="get_map_label")
      import
      type(c_ptr), value :: Element
      integer(c_int), value :: idx
      type(c_ptr) :: ptr
    end function c_yaml_get_map_label


  end interface

end module YAMLInterface
