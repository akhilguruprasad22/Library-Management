#!/bin/bash
menu_choice=""
booksData="bookRecords.ldb"
if [ ! -f borrowed.txt ]
then
	echo -n "" > borrowed.txt
fi

borrowBook(){
  set $(wc -l $booksData)
  linesfound=$1

  case "$linesfound" in
  0) echo "Sorry, nothing found\n"
     getEnter
     return 0
     ;;
  *) echo "Found the following\n"
     cat $booksData ;;
    esac
  printf "Enter name of the borrower: "
  read name
  if [ -z "$name" ]
  then
  	return 0
  fi

  printf "Type the Title/Genre/author of Book(s) which is to be borrowed: "
  read searchstr

  if [ "$searchstr" = "" ]; then
    return 0
  fi
  found=`grep "$searchstr" $booksData`
  if [ ${#found} -eq 0 ]
  then
  	echo "Book does not exist."
  fi
  for i in $found
  do
  	echo "Is this the book you want to borrow?"
  	echo $i
  	read -p "y/n: " ans
  	case $ans in
  		y|Y|yes|YES|Yes) bdate=`date "+%d-%m-%Y"`
						 time=`date "+%H:%M"`
						 echo "Entry to be made: "
						 printf "$name\t$i\t$bdate\t$time\n"
						 printf "$name\t$i\t$bdate\t$time\n" >> borrowed.txt 
						 ;;
		*)break;;
	  esac
  done
  grep -v "$searchstr" $booksData > temp_file
  mv temp_file $booksData
  #printf "Book has been removed\n"
  getEnter
  return
}

getEnter(){
  printf '\tPress return\n'
  read x
  return 0
}
 
confirm(){
  printf '\tAre you sure?[y/n]\n'
  while true
  do
    read x
    case "$x" in
        y|yes|Y|Yes|YES)
            return 0;;
        n|no|N|No|NO)
            printf '\ncancelled\n'
            return 1;;
        *) printf 'Please enter yes or no';;
    esac
  done
}
menu(){
  clear
  printf 'Options:-'
  printf '\n'
  printf '\ta) Add new Books records\n'
  printf '\tb) Find Books\n'
  printf '\tc) Edit Books\n'
  printf '\td) Borrow book(s)\n'
  printf '\te) View list of Borrowed books\n'
  printf '\tf) View all available books\n'
  printf '\tg) Quit\n'
  printf 'Please enter the choice then press return\n'
  read menu_choice
  return
}

insertRecord(){
  echo $* >>$booksData
  return
} 
 
addBook(){ 
  printf 'Enter Books category:-'
  read tmp
  liCatNum=$tmp
  
  printf 'Enter Books title:-'
  read tmp
  liTitleNum=$tmp
  
  printf 'Enter Author Name:-'
  read tmp
  liAutherNum=$tmp
  
  printf 'About to add new entry\n'
  printf "$liCatNum\t$liTitleNum\t$liAutherNum\n"
  
  if confirm; then
    insertRecord $liCatNum,$liTitleNum,$liAutherNum
  fi  
  return
}

findBook(){
  read -p "Enter a string related to the book : " findBook
  grep $findBook $booksData > temp_file
    set $(wc -l temp_file)
    linesfound=$1
  
    case "$linesfound" in
    0)    echo "Sorry, nothing found"
          getEnter
          return 0
          ;;
    *)    echo "Found the following"
          cat temp_file
          getEnter
          return 0
    esac
  return
}

viewBorrowedBooks(){
  entries=`cat borrowed.txt`
  len=${#entries}
  if [ $len == 0 ]
  then
    echo "No books stored yet. Make entry first."
    getEnter
  else
  printf "List of Borrowed books are:\n"  
  cat borrowed.txt
  getEnter
  fi
  return
}
 
viewBooks(){
  entries=`cat $booksData`
  len=${#entries}
  if [ $len == 0 ]
  then
    echo "No books stored yet. Make entry first."
    getEnter
  else
  printf "List of books are:\n"  
  cat $booksData
  getEnter
  fi
  return
}

editBook(){ 
  printf "List of books are\n"
  cat $booksData
  printf "Type the title of book you want to edit\n"
  read searchstr
    if [ "$searchstr" = "" ]; then
      return 0
    fi
    grep -v "$searchstr" $booksData > temp_file
    mv temp_file $booksData
  printf "Enter the new records\n"
  addBook 
}

rm -f temp_file
if [!-f $booksData];then
touch $booksData
fi
 
clear
printf '\n\n\n'
printf 'Mini library Management'
sleep 1
 
quit="n"
while [ "$quit" != "y" ];
do
  #funtion call for choice
  menu
  case "$menu_choice" in
  a) addBook;;
  b) findBook;;
  c) editBook;;
  d) borrowBook;;
  e) viewBorrowedBooks;;
  f) viewBooks;;
  g) quit=y;;
  *) printf "Sorry, choice not recognized";;
  esac
done
 
rm -f temp_file
echo "Finished"
 
exit 0