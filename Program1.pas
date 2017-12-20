program a1;
uses crt;
{$define pDEBUG} 
//{$undef pDEBUG}

Type 
     PStudent = ^TStudent;    //Тип: Указатель на структуру TStudent
     TStudent = record       //Тип: Структура TStudent
        id: integer;
        name: string;
        next: PStudent;
        year: integer; // <--------------- added
        end;
        
     FStudent = record       //Тип: Структура TStudent
        id: integer;
        name: string[10];
        year: integer; // <--------------- added
        end;
        
     TBase = file of FStudent; //Тип: Файл структур TStudent

{$ifdef pDEBUG}
procedure pDebug(s:string);
begin
    writeln('**DEBUG: ',s, '**');
end;
{$else}
procedure pDebug(s:string);
begin
end;
{$endif}

function createItem (_id: integer; _name: string; _year:integer): PStudent; // <--------------- CHANGED
var temp_pointer:PStudent;
begin
    new(temp_pointer);
    temp_pointer^.id := _id;
    temp_pointer^.name := _name;
    temp_pointer^.year := _year;// <--------------- added
    temp_pointer^.next := nil;
    createItem := temp_pointer;
end;

// Процедура для осовобождения памяти по указателю на структуру 
// и обновления указателей
// Принимает: указатель на корневую запись (изменяемый), указатель на структуру
procedure deleteItem (var _root:PStudent; item:Pstudent);
var current, previous:Pstudent;
begin
    if item = nil then exit;
    if item = _root then
    begin       
        writeln ('Удаляется запись ', _root^.id,  _root^.name);
        _root := _root^.next;
        dispose(item);
        pDebug ('Корневая запись изменена');
        exit;
    end;
    
    previous := _root;
    current := _root^.next;
       
     repeat
    begin
        if current = item then
        begin 
            previous^.next := current^.next;
            //writeln ('Удаляется запись ', current^.id,  current^.name);
            dispose(item);
            exit;
        end;
        previous := current;
        current := current^.next;
    end
    until (current=nil);
    
end;

// Функция для поиска структуры по номеру.
// Принимает: указатель на корневую запись, номер зачетки
// Возвращает: указатель на структуру
function findById (_root:PStudent; _id:integer): PStudent;
var current:Pstudent;
begin
    current := _root;   
    repeat
    begin
        if current^.id = _id then 
                begin
                    findById := current;
                    exit;
                end;
        current := current^.next;
    end
    until (current=nil);
    
    pDebug ('Поиск по номеру: записей не найдено!');
    findById := nil;
end;

// Функция для поиска структуры по имени.
// Возвращает: указатель на структуру
function findByName (_root:PStudent; _name:string): PStudent;
var current:Pstudent;
begin
    current := _root;
    repeat
    begin
        if current^.name = _name then 
        begin
            findByName := current;
            exit;
        end;           
        current := current^.next;
    end
    until (current=nil);
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
procedure linkItem(var _root:PStudent; var candidate: PStudent);
var current, previous, temproary:Pstudent;
begin
    //previous := nil;
    if _root=nil then 
    begin
        _root:=candidate;
        exit;
    end;
    
   
        if (selectUpper(_root,candidate)=candidate) then    
        begin
            temproary := _root;
            _root := candidate;
            _root^.next := temproary;
            exit;
         end
         else
         begin
            if _root^.next=nil then
            begin
                 _root^.next := candidate;
                 exit;
            end;
         end;         

        
    previous := _root;
    current := _root^.next;
    
    repeat
    begin
        if selectUpper(current,candidate)=candidate then
        begin 
            previous^.next := candidate;
            candidate^.next := current;
            exit;
        end;
        previous := current;
        current := current^.next;
    end
    until (current=nil);
    previous^.next := candidate;
      
end;

procedure linkItemByYearSorting(var _root:PStudent; var candidate: PStudent);
var current, previous, temproary:Pstudent;
begin
    //previous := nil;
    if _root=nil then 
    begin
        _root:=candidate;
        exit;
    end;
    
   
        //if (selectUpper(_root,candidate)=candidate) then
        if (candidate^.year < _root^.year) then // <--------------- CHANGED
        begin
            temproary := _root;
            _root := candidate;
            _root^.next := temproary;
            exit;
         end
         else
         begin
            if _root^.next=nil then
            begin
                 _root^.next := candidate;
                 exit;
            end;
         end;         

        
    previous := _root;
    current := _root^.next;
    
    repeat
    begin
        //if selectUpper(current,candidate)=candidate then
        if (candidate^.year < current^.year) then // <--------------- CHANGED
        begin 
            previous^.next := candidate;
            candidate^.next := current;
            exit;
        end;
        previous := current;
        current := current^.next;
    end
    until (current=nil);
    previous^.next := candidate;
 end;



procedure loadFromFile (var _root:PStudent; filename :string);       
var tmp_pointer:PStudent; fileItem:FStudent;  f:TBase;
begin 
    if not FileExists(filename) then 
    begin 
        pDebug ('Файл пуст');
        exit;
    end
    else 
    begin 
        assign(f,filename);   
    end;
    reset(f);
    while not EOF(f) do
    begin
        read(f,fileItem);
        tmp_pointer := createItem (fileItem.id, fileItem.name, fileItem.year); 
        //linkItem(_root, tmp_pointer);
        linkItemByYearSorting(_root, tmp_pointer); //< ---------------- CHANGED
    end;
    close(f);      
end;



procedure saveToFile (var _root:PStudent; filename :string);       
var current:Pstudent; fileItem:FStudent;  f:TBase;
begin 
    assign(f,filename); 
    rewrite(f); 
    current := _root;
    if not(_root=nil) then
    begin
        current := _root;
    end
    else
    begin
        pDebug('Список пуст!');
        exit;
    end;
    repeat
    begin
        fileItem.id := current^.id;
        fileItem.name := current^.name;
        fileItem.year := current^.year;
        write(f,fileItem);
        current := current^.next;
    end
    until (current=nil);
    close(f);      
end;

procedure showList (_root:PStudent);
var current:Pstudent;
begin
    clrscr();  
    writeln ('Список в опреативной памяти:');
    writeln (' ________________________________________');
    writeln ('|   Номер  |   Фамилия И.О.     | Год    |');     // < ------------------CHANGED
    if not(_root=nil) then
    begin
        current := _root;
    end
    else 
    begin
        writeln ('Список пуст...');
        writeln ('|_______________________________|');
        readln();
        exit;
    end; 
    repeat
    begin
        writeln ('| ',current^.id, '   ',current^.name, '   ',current^.year);    // < ------------------CHANGED                 
        current := current^.next;
    end
    until (current=nil);
        writeln ('|_______________________________|');
    readln();
end;

procedure drawMenu();
begin
    clrscr;
    writeln('                      Главное меню                            ');
    writeln('Выберите действие путем ввода соответствующей цифры в консоль:');
    writeln('1.  Добавить запись...');
    writeln('2.  Найти и удалить запись...');
    writeln('3.  Вывести список на экран');
    writeln('0.  Завершить работу');   
end;

procedure addItemDialog(var _root:PStudent);
var tmp_pointer:PStudent; _name:string; var _id, _year:integer; // <---------------------- CHANGED   
begin
    clrscr;
    writeln('                      Добавление записи                      ');
    write(' Введите ФИО студента: ');
    readln(_name);
    write(' Введите номер зачетной книжки: ');
    readln(_id);  
    write(' Введите год рождения: ');     // <---------------------- ADDED
    readln(_year);                        // <---------------------- ADDED
    tmp_pointer := createItem (_id, _name, _year);  // <---------------------- CHANGED   
   // linkItem(_root, tmp_pointer);
    linkItemByYearSorting(_root, tmp_pointer);  // <---------------------- CHANGED   
    write(' Создана запись: ');
    writeln ('ФИО: ', tmp_pointer^.name, ', Номер зачетной книжки: ', tmp_pointer^.id, ', Год рождения: ', tmp_pointer^.year); // <---------------------- CHANGED 
    if tmp_pointer = _root then write(' Добавлена в начало списка. '); 
    if tmp_pointer^.next = nil then write(' Добавлена в конец списка. ')
    else write(' Добавлена перед записью ', tmp_pointer^.next^.id, '  ', tmp_pointer^.next^.name, ' ', tmp_pointer^.next^.year); // <---------------------- CHANGED 
    readln();  
end;

procedure findAndDeleteDialog(var _root:PStudent);
var tmp_pointer:PStudent; _name:string; _id:integer; action: integer;
begin 
  
    while (true) do
	begin
    	clrscr;
        writeln('                      Поиск и удаление записи                      ');
        writeln('Выберите действие путем ввода соответствующей цифры в консоль:');
        writeln('1 - поиск по ФИО студента ');
        writeln('2 - поиск по номеру зачетной книжки студента ');
        writeln('3 - поиск по ФИО и номеру зачетной книжки студента ');
        writeln('0 - выход в главное меню ');
	   readln (action);
       if action=0 then exit;
	   case action of
      1: begin
            write('ФИО студента: '); 
            readln (_name);
            tmp_pointer := findByName(_root, _name);
            if tmp_pointer=nil then
            begin
                writeln ('Запись c ФИО ', _name, ' не найдена! Повторите ввод.');
                readln();
            end
            else break;
         end;
      2: begin
            write(' Введите номер зачетной книжки: ');
            readln(_id);
            tmp_pointer := findById(_root, _id);
            if tmp_pointer=nil then
            begin
                writeln ('Запись по номеру' ,_id, ' не найдена! Повторите ввод.');
                readln();
            end
            else break;
         end;
      3: begin
            write(' Введите номер зачетной книжки: ');
            readln(_id);
            write('ФИО студента: '); 
            readln (_name);
            tmp_pointer := findByNameAndId(_root, _name,_id);
            if tmp_pointer=nil then
            begin
                writeln ('Запись c номером' ,_id, 'и именем ', _name, ' не найдена! Повторите ввод.');
                readln();
            end
            else break;
         end
      end;    
	end;
          writeln ('Найдена запись:');
      writeln ('ФИО: ', tmp_pointer^.name, ', Номер зачетной книжки: ', tmp_pointer^.id, ', Год рождения: ', tmp_pointer^.year);  // <---------------------- CHANGED
      writeln ('Удалить запись? 1-удалить, 0-выход');
      while (true) do
      begin
            readln (action);
           if action=0 then exit;
           if action=1 then
           begin
                deleteItem(_root, tmp_pointer);
                break;
           end;
      end;  
      writeln ('Запись удалена.'); read();
 
end;




var root:PStudent; filename:string; tmp_pointer:PStudent; action: integer;  // Глобальные переменные
begin //Тело программы
    pDebug('DEBUGGING ENABLED');  
    filename := 'students.base';
    loadFromFile(root,filename);

    while (true) do
      begin
        drawMenu();
        readln (action);
       if action=0 then break;
       case action of
           1: addItemDialog(root);
           2: findAndDeleteDialog(root);
           3: showList(root);
       end;    
	end;
  
    
    saveToFile(root,filename);

    

end.