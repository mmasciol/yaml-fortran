!> YAML is a data serialization language designed to be human-readable for transfering stateless
!> data in and out of programs. YAML is fully operational through three basic primitives: mappings
!> (hashes/dictionaries), sequences (arrays/lists) and scalars (strings/numbers).  This fortran
!> interface supports the extraction of these primitives. You can read more about the [YAML
!> specification here](https://yaml.org/spec/1.2.2/).
!>
!> ???+ info
!>     This library only supports YAML reading/parsing, not the creation or generation of YAML files.
!>
!> This project depends on the C++ project [YAML-cpp](https://github.com/jbeder/yaml-cpp). A C wrapper is created
!> to connect Fortran with the YAML-cpp library and acts as a client to broker information between YAML-cpp and the Fortran destination.
!> As this thin wrapper layer is an interface to the YAML-cpp implementation, most users do not need to be famliar with
!> YAML-cpp in order to use the YAML Fortran library. This documentation should be all a developer needs in order to begin using it.
!>
!> ## Terminology
!>
!> ### Access Types
!> * **Handlers** are the YAML file pointers; see [YAMLHandler](#yamlhandler)
!> * **Sequences** are iterators, lists or arrays; see [YAMLSequence](#yamlsequence)
!> * **Maps** are key-value pairs; see [YAMLMap](#yamlmap)
!> * **Elements** are individual items in a YAMLSequence list; see [YAMLElement](#yamlelement)
!> * **Fields** are scalar values, matrices, or strings. They represent terminus data in the YAML file; see [YAMLField](#yamlfield)
!>
!> ## Reading a YAML File
!>
!> Our objective is to read value fields `parent_1` and `parent_2` from the following YAML `input.yaml` file:
!>
!> ```yaml
!> parent_1:  # a map
!>     child_a:
!>         boolean_flag: true
!>         an_aray: [0.999, 1.0]
!>         array_int_2d: [[1,   2,  3],[4,   5,  6],[7,   8,  9],[10, 11, 12]]
!> parent_2:  # a sequence
!>   - item: 3 x 3 matrix.
!>     value: [[1, 2, 3],[4, 5, 6],[7, 8, 9],[10, 11, 12]]
!>   - item: 4 x 3 matrix
!>     value: item_is_float_array_2d: [[1, 2, 3],[4, 5, 6],[7, 8, 9],[10, 11, 12]]
!> ```
!>
!> Keys `parent_1` ad `parent_2` represent a map and a sequence, respectively. Shortly we will demonstrate
!> a structure to read both items from the YAML file.
!>
!> ### Read a Map
!>
!> The syntax for reading a map is:
!>
!> ```fortran
!> use YAMLRead
!> character(len=:), allocatable :: fpath
!> type(YAMLHandler) :: domain
!> type(YAMLMap) :: parent
!> type(YAMLMap) :: mapper
!> integer :: code = 0
!>
!> fpath = "./input.yaml"
!>
!> domain = yaml_open_file(fpath)
!> parent = yaml_start_from_map(domain, "parent_1")
!> mapper = parent%value_map("child_a")
!>
!> write(*,*) "map values = ", mapper%value_str("boolean_flag", code)
!> write(*,*) "map values = ", mapper%value_double_1d("an_aray", code)
!> write(*,*) "map values = ", mapper%value_int_2d("array_int_2d", code)
!>
!> call mapper%destroy()
!> call parent%destroy()
!> call yaml_close_file(domain)
!> deallocate(fpath)
!> ```
!>
!> After importing the `YAMLRead` module, the next step is to declare the variables we will use. A [YAMLHandler](#yamlhandler)
!> instance stores the file pointer and two [YAMLMap](#yamlmap)'s are declared as entry points into the
!> `parent_1` and `child_a` maps. Each hierarchial level requires its own YAMLMap declaration in order to safely manage
!> memory associated with those nodes. Therefore, a YAMLMap cannot be resued once it is assigned unless it is destroyed.
!>
!> Next, we use the [yaml_start_from_map](#yaml_start_from_map) function to retrieve the lead
!> node to designate a location to start scouring the YAML file. Both `parent_1` and `parent_2` are valid lead nodes in the example file above.
!> Now with the lead node set, we retrieve the `child_a` map through the `value_map` module procedure:
!>
!> ```fortran
!> mapper = parent%value_map("child_a")
!> ```
!>
!> As demonstrated above, there's a different mechanism to access YAML nodes after the lead node is selected.
!> Although it's debatable whether this is a good idea, this decoration exists in order to preserve a consistent
!> access style we see with the YAML-cpp library. Each key value can be accessed using:
!>
!> ```fortran
!> write(*,*) "mapper values = ", mapper%value_str("boolean_flag", code)
!> write(*,*) "mapper values = ", mapper%value_double_1d("an_aray", code)
!> write(*,*) "mapper values = ", mapper%value_int_2d("array_int_2d", code)
!> ```
!>
!> to print YAML content to the console. Objects are deleted in the reverse order they were
!> allocated to release memory. The `code` argument is an exit code. If value extraction is
!> successful then `code == 0`, otherwise it is another positive value.
!>
!> ### Read a Sequence
!>
!> Reading a sequence is similiar to maps:
!>
!> ```fortran
!> use YAMLRead
!> character(len=:), allocatable :: fpath
!> type(YAMLHandler) :: domain
!> type(YAMLSequence) :: seq
!> type(YAMLElement) :: elem
!> integer :: n, i
!>
!> fpath = "./input.yaml" !
!> domain = yaml_open_file(fpath)
!> seq = yaml_start_from_sequence(domain, "parent_2")
!>
!> elem = seq%element(0)
!>
!> write(*,*) "element 1 = ", elem%value_str("item", code)
!> write(*,*) "element 1 = ", elem%value_int_2d("value", code)
!>
!> n = size(elem%labels)
!> do i = 1,n
!>   write(*,*) "  ", elem%labels(i)%str
!> end do
!>
!> call elem%destroy()
!> call seq%destroy()
!> call yaml_close_file(domain)
!> deallocate(fpath)
!> ```
!>
!> One obvious difference is the delcaration of `yaml_start_from_sequence` to access the `parent_2` lead node.
!> This function call is necessary since `parent_2` is a sequence. Another key difference is the declaration of
!> [YAMLSequence](#yamlsequence) and [YAMLElement](#yamlelement) types in order to access interior
!> parts of the sequence.
!>
!> Once variable `seq` is assigned, then interior elements can be accessed using the `element(...)` module
!> procedure. Th inpur argument to this procedure is zero-indexed; thus if we wanted to access the second
!> sequence entry, then the artgument is `element(1)`. Sequence values are queried using the `value_<>` getters,
!> a similiarity shared with maps. Resources are destroyed in the reverse order they are allocated.
module YAMLRead

  use iso_c_binding
  use iso_fortran_env
  use YAMLInterface

  implicit none
  private

  public :: yaml_open_file
  public :: yaml_start_from_sequence
  public :: yaml_start_from_map
  public :: yaml_close_file
  public :: YAMLMap
  public :: YAMLHandler
  public :: YAMLSequence
  public :: YAMLElement


  type :: StringsType
    character, allocatable :: str(:)
  end type StringsType


  type YAMLHandler
    !> ### YAMLHandler
    !>
    !> This object is an interoperable abstract type to access YAML configuration
    !> object. The configuration object object is the "root" of the YAML file.
    !> allowing access to YAML::Node objects. We never acces the YAML::Node object
    !> directly in this interface because there is no need to do so.
    !>
    !> > * **c_obj:** opaque pointer to C++ YAML::Node context manager
    type(c_ptr) :: ptr
  end type YAMLHandler


  type, bind(c) :: YAMLField
    !> ### YAMLField
    !>
    !> Type for retriving any terminating field in the YAML file. Variable `c_obj` is a generic type
    !> `void*`,and the `c_type_enum` is used for casting the `c_obj void*` to the correct type.
    !>
    !> > * **c_obj:** opaque pointer to C++ YAML::Node context manager
    !> > * **m:** matrix row size; used exclusively when `c_obj` is a `double**` or `int**`
    !> > * **n:** matrix column size
    !> > * **c_type_enum:** Enumeration corresponding data type passed between the C wrapper and Fortran
    type(c_ptr) :: c_obj = c_null_ptr  !
    integer(c_int) :: m = -9999
    integer(c_int) :: n = -9999
    integer(c_int) :: c_type_enum
  end type YAMLField


  type YAMLSequence
    !> ### YAMLSequence
    !>
    !> A YAMLSequence is a list of [YAMLMap](#YAMLMap) under the hood.
    !>
    !> > * **ptr:** opaque pointer to C Sequence struct
    !> > * **size:** sequence size; must be positive
    type(c_ptr) :: ptr
    integer :: size
  contains
    procedure :: destroy => sequence_destroy
    procedure :: element => sequence_get_element
  end type YAMLSequence


  type YAMLMap
    !> ### YAMLMap
    !>
    !> Value-key pairs (or hash mappings) of YAML entries.
    !>
    !> > * **ptr:** opaque pointer to C Map struct
    !> > * **idx:** array position number of this map instance; index starts at zero.
    !> > * **labels:** list of keys available in a map instance
    type(c_ptr) :: ptr
    integer :: idx
    type(StringsType), allocatable :: labels(:)
  contains
    procedure :: destroy => map_destroy
    procedure :: value_int => map_value_int
    procedure :: value_str => map_value_str
    procedure :: value_double => map_value_double
    procedure :: value_int_1d => map_value_int_1d
    procedure :: value_double_1d => map_value_double_1d
    procedure :: value_double_2d => map_value_double_2d
    procedure :: value_int_2d => map_value_integer_2d
    procedure :: value_sequence => map_value_sequence
    procedure :: value_map => map_value_map
  end type YAMLMap

  type, extends(YAMLMap) :: YAMLElement  ! this is a map / struct list
    !> ### YAMLElement
    !>
    !> Value-key pairs (or hash mappings) of YAML entries.
    !>
    !> > * **isValid:** boolean flag informing users the element is valid and initialized.
    logical :: isValid = .false.
  contains
    procedure :: destroy => element_destroy
  end type YAMLElement

  contains


    subroutine sequence_destroy(this)
      class(YAMLSequence), intent(inout) :: this

      call c_yaml_destroy_sequence(this%ptr)
    end subroutine sequence_destroy


    function sequence_get_element(this, idx) result(element)
      !> ### sequence_get_element
      !>
      !> Retrieves the sequence index. The returned item is a vector
      !>
      !> > * *Returns:* [YAMLElement](#yamlelement)
      !> > * **idx:** index number, zero indexed
      class(YAMLSequence), intent(inout) :: this
      integer, intent(in) :: idx

      type(YAMLElement) :: element
      integer(c_int) :: n = 0

      n = idx
      if (idx < this%size) then
        element%ptr = c_yaml_get_map_from_sequence(this%ptr, n)
        element%idx = idx
        element%isValid = .true.
        call p_try_set_map_labels(element)
      else
        write(*,*) "[ERROR] index out of bounds"  ! @todo: raise proper error
      end if
      return
    end function sequence_get_element


    subroutine p_try_set_map_labels(mapper)
      type(YAMLElement), intent(inout) :: mapper

      integer(c_int) :: n_maps = 0
      type(c_ptr) :: ptr
      character(c_char), dimension(:), pointer :: fptr
      integer(c_int) :: i = 0

      n_maps = c_yaml_get_map_size(mapper%ptr)
      allocate(mapper%labels(n_maps))

      do i = 0,n_maps-1
        ptr = c_yaml_get_map_label(mapper%ptr, i)
        call C_F_POINTER(ptr, fptr, [strlen(ptr)])
        mapper%labels(i+1)%str = fptr
      end do
    end subroutine p_try_set_map_labels


    subroutine p_set_map_labels(mapper)
      type(YAMLMap), intent(inout) :: mapper

      integer(c_int) :: n_maps = 0
      type(c_ptr) :: ptr
      character(c_char), dimension(:), pointer :: fptr
      integer(c_int) :: i = 0

      n_maps = c_yaml_get_map_size(mapper%ptr)
      allocate(mapper%labels(n_maps))

      do i = 0,n_maps-1
        ptr = c_yaml_get_map_label(mapper%ptr, i)
        call C_F_POINTER(ptr, fptr, [strlen(ptr)])
        mapper%labels(i+1)%str = fptr
      end do
      end subroutine p_set_map_labels


    function p_get_field(mapper, key, cptr_field) result(field)
      !> ### p_get_field
      !>
      !> Retrieves the C struct ListProperty item uing the supplied key
      !>
      !> *Returns:*
      !>
      !> > * **mapper:** YAMLMap or YAMLElement
      !> > * **key:** key present in the `yaml` sequence, mapping, or list
      !> > * **cptr_field:** opaque pointer to the a struct Field in C
      type(YAMLMap), intent(in) :: mapper
      character(len=*), intent(in) :: key
      type(c_ptr), intent(inout) :: cptr_field
      character(len=256), target :: tlabel
      type(YAMLField), pointer :: field

      type(c_ptr) :: ptr

      tlabel = key//C_NULL_CHAR
      ptr = c_loc(tlabel)
      cptr_field = c_yaml_get_field(mapper%ptr, ptr)
      call c_f_pointer(cptr_field, field)
      return
    end function p_get_field


    function map_value_map(this, key) result(mapper)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key

      type(YAMLMap) :: mapper
      character(len=256), target :: arr
      type(c_ptr) :: ptr
      type(c_ptr) :: field

      arr = trim(key)//C_NULL_CHAR
      ptr = C_LOC(arr)

      field = c_yaml_get_field(this%ptr, ptr)
      mapper%ptr = c_yaml_get_map_from_field(field)
      call p_set_map_labels(mapper)
      call c_yaml_destroy_field(field)
      return
    end function map_value_map


    function map_value_sequence(this, key, code) result(seq)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      type(YAMLSequence), pointer :: argc
      type(YAMLSequence) :: seq

      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_SEQUENCE) then
        write(*,*) "[ERROR  ][YAML ] Type does not match value returned by yaml-cpp [node], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

      call c_f_pointer(field%c_obj, argc)

      seq%ptr = field%c_obj
      seq%size = c_yaml_get_sequence_size(seq%ptr)
      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_sequence


    function map_value_int(this, key, code) result(fint)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      integer(c_int), pointer :: argc
      integer :: fint

      code = 0
      fint = -9999
      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_INT) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [int], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

      call c_f_pointer(field%c_obj, argc)

      fint = argc
      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_int


    function map_value_int_1d(this, key, code) result(fint_1d)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      integer(c_int), pointer :: argc(:)
      integer, allocatable :: fint_1d(:)

      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_INT_1D) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [int 1d], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

       allocate(fint_1d(field%m))
        call c_f_pointer(field%c_obj, argc,  [field%m])

      fint_1d = argc
      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_int_1d


    function map_value_double_1d(this, key, code) result(fdouble_1d)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      real(c_double), pointer :: argc(:)
      real(real64), allocatable :: fdouble_1d(:)

      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_DOUBLE_1D) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [double 1d], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

       allocate(fdouble_1d(field%m))
        call c_f_pointer(field%c_obj, argc,  [field%m])

      fdouble_1d = argc
      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_double_1d


    function map_value_double_2d(this, key, code) result(fdouble_2d)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      real(c_double), pointer :: argc(:)
      real(real64), allocatable :: fdouble_2d(:,:)
      integer ::i = 0
      integer ::j = 0

      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_DOUBLE_2D) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [double 2d], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

      allocate(fdouble_2d(field%m, field%n))
      call c_f_pointer(field%c_obj, argc,  [field%m * field%n])

      do i = 1, field%m
        do j = 1,field%n
              fdouble_2d(i,j) = argc((i-1)*field%n + j)
        end do
      end do

      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_double_2d


    function map_value_integer_2d(this, key, code) result(fint_2d)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      integer(c_int), pointer :: argc(:)
      integer, allocatable :: fint_2d(:,:)
      integer ::i = 0
      integer ::j = 0

      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_INT_2D) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [integer 2d], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

      allocate(fint_2d(field%m, field%n))
      call c_f_pointer(field%c_obj, argc,  [field%m * field%n])

      do i = 1, field%m
        do j = 1,field%n
              fint_2d(i,j) = argc((i-1)*field%n + j)
        end do
      end do

      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_integer_2d


    function map_value_double(this, key, code) result(fdouble)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      real(c_double), pointer :: argc
      real(real64) :: fdouble

      fdouble = -999.9
      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_DOUBLE) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [double], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

      call c_f_pointer(field%c_obj, argc)

      fdouble = argc
      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_double


    function map_value_str(this, key, code) result(fstr)
      class(YAMLMap), intent(inout) :: this
      character(len=*), intent(in) :: key
      integer, intent(inout) :: code

      type(c_ptr) :: cptr_field
      type(YAMLField) :: field
      character(c_char), pointer :: argc(:)
      character, allocatable :: fstr(:)

      field = p_get_field(this, key, cptr_field)

      if (field%c_type_enum /= YAML_STRING) then
        write(*,*) "[ERROR  ][YAML ] type does not match value returned by yaml-cpp [str], but type ", field%c_type_enum  ! @todo: raise proper error
        code = 400  ! ERROR
        call c_yaml_destroy_field(cptr_field)
        return
      end if

      call c_f_pointer(field%c_obj, argc, [field%n])

      fstr = argc(1:size(argc))
      call c_yaml_destroy_field(cptr_field)
      return
    end function map_value_str


    subroutine map_destroy(this)
      class(YAMLMap), intent(inout) :: this

      integer :: n = -9999
      integer :: i = -9999

      n = size(this%labels)

      do i = 1,n
        if (allocated(this%labels)) then
          deallocate(this%labels(i)%str)
        end if
      end do
      if (allocated(this%labels)) then
        deallocate(this%labels)
      end if

      call c_yaml_destroy_map(this%ptr)
    end subroutine map_destroy


    subroutine element_destroy(this)
      class(YAMLElement), intent(inout) :: this

      integer :: n = -9999
      integer :: i = -9999

      n = size(this%labels)

      do i = 1,n
        if (allocated(this%labels)) then
          deallocate(this%labels(i)%str)
        end if
      end do
      if (allocated(this%labels)) then
        deallocate(this%labels)
      end if
    end subroutine element_destroy



    ! Entry / exit points into the yaml library
    !

    function yaml_open_file(fpath) result(handler)
      !> ### yaml_open_file
      !>
      !> Opens a YAML file and return a YAMLHander instance.
      !> Subroutine `yaml_close_file` must be called on each
      !> file opened with this function.
      !>
      !> > * *Returns:* [YAMLHandler](yamlhndler) object
      !> > * **fpath:** Path to YAML file. Can be absolute or relative.
      character(len=*), intent(in) :: fpath

      character(256), pointer :: fstr  ! @todo: dynamically allocated instead?
      type(c_ptr) :: cstr
      type(YAMLHandler) :: handler
      integer :: n
      integer :: i = 0

      n = len(fpath) + 1

      allocate(fstr)

      do i = 1,n - 1
        fstr(i:i) = fpath(i:i)
      end do

      fstr(n:n) = C_NULL_CHAR
      cstr = C_LOC(fstr)

      handler%ptr = c_yaml_load_file(cstr)

      deallocate(fstr)
      return
    end function yaml_open_file


    function yaml_start_from_sequence(handler, key) result(seq)
      !> ### yaml_start_from_sequence
      !>
      !> Return a YAML sequence. A sequnce is an array or list. Opens a YAML file and return a YAMLHander instance.
      !> Subroutine `yaml_close_file` must be called on each
      !> file opened with this subroutine.
      !>
      !> > * *Returns* [YAMLSequence}(#yamlsequence)]
      !> > * **key:** lead starting sequence key
      !> > * **handler:** YAMLHandler object
      type(YAMLHandler), intent(in) :: handler
      character(len=*), intent(in) :: key

      character(len=256), target :: arr
      type(c_ptr) :: ptr
      type(YAMLSequence) :: seq

      arr = trim(key)//C_NULL_CHAR
      ptr = C_LOC(arr)

      seq%ptr = c_yaml_start_from_sequence(handler%ptr, ptr)
      seq%size = c_yaml_get_sequence_size(seq%ptr)
      return
    end function yaml_start_from_sequence


    function yaml_start_from_map(handler, key) result(mapper)
      !> ### yaml_start_from_map
      !>
      !> Return a YAML sequence. A sequnce is an array or list. Opens a YAML file and return a YAMLHander instance.
      !> Subroutine `yaml_close_file` must be called on each
      !> file opened with this subroutine.
      !>
      !> > * *Returns:* [YAMLMap](#yamlmap)
      !> > * **key:** Path to YAML file. Can be absolute or relative.
      type(YAMLHandler), intent(in) :: handler
      character(len=*), intent(in) :: key

      character(len=256), target :: arr
      type(c_ptr) :: ptr
      type(YAMLMap) :: mapper

      arr = trim(key)//C_NULL_CHAR
      ptr = C_LOC(arr)

      mapper%ptr = c_yaml_start_from_map(handler%ptr, ptr)
      mapper%idx = 0
      call p_set_map_labels(mapper)
      return
    end function yaml_start_from_map


    subroutine yaml_close_file(handler)
      !> ### yaml_close_file
      !>
      !> Closes the YAML file and deallocated any memory associated with the YAML instance.
      !>
      !> > * **hanlder:** [YAMLHandler](#yamlhndler) object
      type(YAMLHandler), intent(inout) :: handler

      call c_yaml_destroy_domain(handler%ptr)
    end subroutine yaml_close_file


end module YAMLRead
