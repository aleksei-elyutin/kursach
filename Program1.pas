program a1;
//uses crt;

Type 
     PStudent = ^TStudent;
     TStudent = record
        id: integer;
        name: string;
        next: PStudent;
        end;
      TBase = file of TStudent;

function createItem (_id: integer; _name: string ): PStudent;
var temp_pointer:PStudent;
begin
    new(temp_pointer);
    temp_pointer^.id := _id;
    temp_pointer^.name := _name;
    temp_pointer^.next := nil;
end;

// Процедура для осовобождения памяти по указателю на структуру 
// и обновления указателей
// Принимает: указатель на корневую запись (изменяемый), указатель на структуру
procedure deleteItem (var _root:PStudent; item:Pstudent);
var current, previous:Pstudent;
begin
    if item = _root then
    begin
        _root := _root^.next;
        writeln ('Удаляется запись ', _root^.id,  _root^.name);
        dispose(item);
        exit;
    end;
    current := _root^.next;
    while not (current^.next=nil) do
    begin
        if current = item then
        begin
            previous^.next := current^.next;
            writeln ('Удаляется запись ', current^.id,  current^.name);
            dispose(current);
            exit;
        end;
        previous := current;
        current := current^.next;
    end;
end;

// Функция для поиска структуры по номеру.
// Принимает: указатель на корневую запись, номер зачетки
// Возвращает: указатель на структуру
function findById (_root:PStudent; _id:integer): PStudent;
var current:Pstudent;
begin
    current := _root;
    while not (current^.next=nil) do
    begin
        if current^.id = _id then 
        begin
            findById := current;
            exit;
        end;
        current := current^.next;
    end;
    writeln ('Поиск по номеру: записей не найдено!');
    findById := nil;
end;

// Функция для поиска структуры по имени.
// Возвращает: указатель на структуру
function findByName (_root:PStudent; _name:string): PStudent;
var current:Pstudent;
begin
    current := _root;
    while not (current^.next=nil) do
    begin
        if current^.name = _name then 
        begin
            findByName := current;
            exit;
        end;           
        current := current^.next;
    end;
    writeln ('Поиск по имени: записей не найдено!');
    findByName := nil;
end;

// Функция для поиска структуры по имени и номеру.
// Возвращает: указатель на структуру
function findByNameAndId (_root:PStudent; _name:string; _id: integer): PStudent;
var temproary:Pstudent;
begin
    temproary := findById (_root, _id);
    if temproary^.name = _name then
    begin   
        findByNameAndId := temproary;
        exit;
    end;
    writeln ('Поиск по имени и номеру: записей не найдено!');
    findByNameAndId := nil;
end;

// Принимает два указателя на структуры TStudent.
// Возвращает указатель на структуру, значение поля Имя в которой стоит выше 
// в алфавитном порядке
function selectUpper(item1, item2: PStudent) : PStudent;
var selected_len, len1, len2: integer;
begin
    len1 := length(item1^.name); 
    len2 := length(item2^.name);
    if (len1 <= len2) then
    selected_len := len1
    else selected_len := len2;
    for  i:integer:=1 to selected_len do
    begin        
        if (item1^.name[i]<item2^.name[i]) then
        begin
             selectUpper := item1;
            break;
        end
        else if (item1^.name[i]>item2^.name[i]) then
        begin
            selectUpper := item2;
            break;
        end;
    end;
    
end;

// Процедура добавления записи в нужное положение в алфавитном порядке
// с обновлением указателей
// Принимает: указатель на корневую запись (изменяемый), указатель 
// на добавляемую структуру
procedure linkItem(var _root:PStudent; candidate: PStudent);
var current, previous, temproary:Pstudent;
begin
    previous := nil;
    if _root=nil then 
    begin
        _root:=candidate;
        exit;
    end;
    
    if _root^.next = nil then
    begin
        if selectUpper(_root,candidate)= candidate then
        temproary := _root;
        _root := candidate;
        _root^.next := temproary;
        exit;
    end;
    
    current := _root;
    while not (current^.next=nil) do
    begin
        if selectUpper(current,candidate)=candidate then
        begin
            if current=_root then
            begin
                temproary := _root;
                _root := candidate;
                _root^.next := temproary;
                exit;
            end;
            previous^.next := candidate;
            candidate^.next := current;      
            exit;
        end;
        candidate^.next := current;
        previous := current;
        current := current^.next;
    end;
    
        
end;

procedure loadFromFile ()
        
var 
    filename :string; s1, s2:string; f:TBase;

begin //Тело программы
  
filename := 'students.base';
f

      

end.