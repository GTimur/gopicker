package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"

	"golang.org/x/text/encoding/charmap"
	"golang.org/x/text/transform"
)

func main() {
	fmt.Println("GoPicker by GTG (C) 2019 ver. 0.3.1")

	var fFile = flag.String("file", "", "Имя файла или маска для обработки. Пример: filename.dat или *.xml")
	var fDst = flag.String("dst", ".", "Корневая директория для дерева dst\\YYYY\\MM\\DD. Пример: \"C:\\temp\\dst\"")
	var fSilent = flag.Bool("silent", false, "Вкл./выкл. сообщения в процессе обработки.")
	var fFindOnly = flag.Bool("findOnly", false, "Если true - перемещение откл., работает только фитрация и копирование.")
	var fFindPhrase = flag.String("findPhrase", "", "Фраза для поиска в файле. Ипользуется вместе с finddir")
	var fFindContains = flag.String("findNameContains", "", "Если finddir не пусто - то задает подстроку в имени файла для фильтра с finddir. Пример: ED211")
	var fFindDir = flag.String("findDir", "", "Если не пусто - то будет создан подкаталог finddir, в который копируются файлы по маске findnamecontains содержащие строку phrase")

	flag.Parse()

	args := os.Args
	if len(args) == 1 || len(*fFile) == 0 {
		fmt.Println("USAGE: GoPicker.exe --help or -h for help")
		fmt.Println("       GoPicker.exe -file=\"c:\\temp\\filename.ext\"")
		fmt.Println("       GoPicker.exe -file=\"*Jan*.xml\"")
		os.Exit(1)
	}

	curdir := filepath.Dir(*fFile)
	if len(curdir) == 0 {
		curdir = "."
	}

	fileslist, err := FindFiles(curdir, []string{*fFile})
	if err != nil {
		fmt.Println("File preparing error:", err)
		os.Exit(1)
	}

	var folderPath string
	var check bool

	for k, _ := range fileslist {
		// get last modified time
		file, err := os.Stat(k)
		if err != nil {
			fmt.Println("Error opening file:", k)
			os.Exit(1)
		}
		modifiedtime := file.ModTime()
		YYYY := fmt.Sprintf("%04d", modifiedtime.Year())
		MM := fmt.Sprintf("%02d", modifiedtime.Month())
		DD := fmt.Sprintf("%02d", modifiedtime.Day())

		folderPath = *fDst + "\\" + YYYY + "\\" + MM + "\\" + DD

		//Если используется фильр FindDir FindPhrase fFindContains
		if len(*fFindDir) > 0 {
			check = false
			if len(*fFindContains) > 0 {
				check = strings.Contains(k, *fFindContains)
			}
			if len(*fFindPhrase) > 0 {
				check, err = PhraseIsExist(*fFindPhrase, k)
				if err != nil {
					fmt.Printf("PhraseSearch error: %v", err)
					break
				}
			}
			if check {
				folderPath = *fDst + "\\" + YYYY + "\\" + MM + "\\" + DD + "\\" + *fFindDir
			}
		}

		if err := os.MkdirAll(folderPath, 0777); err != nil {
			fmt.Printf("Mkdir error: %v", err)
			break
		}

		// Если FindDir FindPhrase fFindContains фильтр включен - делаем копию файла
		if check {
			if !*fSilent {
				fmt.Printf("Copying file [%s] to [%s]...\n", k, folderPath)
			}
			if err := MakeCopy(k, path.Join(folderPath, k)); err != nil {
				fmt.Printf("Copying file error: %v", err)
				break
			}
		}

		//Восстановим значение для дерева каталогов
		folderPath = *fDst + "\\" + YYYY + "\\" + MM + "\\" + DD

		//Восстановим значение проверок для фильтров
		check = false
		if *fFindOnly {
			continue
		}

		if !*fSilent {
			fmt.Printf("Moving file [%s] to [%s]...\n", k, folderPath)
		}
		if err := Move(k, path.Join(folderPath, k)); err != nil {
			fmt.Printf("Moving file error: %v", err)
			break
		}
	}

}

//Move - Переносит файлы (работает только в рамках одного диска)
func Move(src string, dst string) error {
	err := os.Rename(src, dst)
	if err != nil {
		return err
	}
	return err
}

//FindFiles - search files in folder by selected masks
func FindFiles(dir string, mask []string) (files map[string]string, err error) {
	var list []string
	files = make(map[string]string)

	for i := range mask {
		list, err = filepath.Glob(dir + "\\" + strings.ToUpper(mask[i]))
		if err != nil {
			log.Println("FindFiles error: ", err)
			return nil, err
		}
		//files = append(files, list...)
		for _, f := range list {
			files[f] = mask[i]
		}
	}
	for i := range mask {
		list, err = filepath.Glob(dir + "\\" + strings.ToLower(mask[i]))
		if err != nil {
			log.Println("FindFiles error: ", err)
			return nil, err
		}
		//files = append(files, list...)
		for _, f := range list {
			files[f] = mask[i]
		}
	}
	return files, err
}

//FindAllFiles - search files in all subdirectories by selected masks
func FindAllFiles(rootdir string, mask []string) (files map[string]string, err error) {
	var dirs []string
	files = make(map[string]string)

	dirs, err = FindAllDirs(rootdir, "")
	if err != nil {
		log.Fatalf("FindAllFiles error: %v", err)
	}

	for _, k := range dirs {
		f, err := FindFiles(k, mask)
		if err != nil {
			log.Fatalf("FindAllFiles error: %v", err)
		}

		for kk := range f {
			files[kk] = filepath.Dir(kk)
		}
	}
	return files, err
}

// FindAllDirs - ищет все директории, включая вложенные,  в корневой
func FindAllDirs(rootdir string, subDirToSkip string) (files []string, err error) {

	/*	err = os.Chdir(rootdir)
		if err != nil {
			fmt.Printf("error chdir the path %q: %v\n", rootdir, err)
			return
		}*/

	err = filepath.Walk(rootdir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			fmt.Printf("Failure accessing path %q: %v\n", path, err)
			return err
		}
		if info.IsDir() && info.Name() == subDirToSkip {
			//skipping a dir
			return filepath.SkipDir
		}
		//save dir
		files = append(files, path)
		return nil
	})
	if err != nil {
		fmt.Printf("error walking the path %q: %v\n", rootdir, err)
		return
	}

	return
}

// PhraseIsExist - Проверяет наличие фразы в файле
func PhraseIsExist(str, filepath string) (isExist bool, err error) {
	enc := charmap.Windows1251

	f, err := os.Open(filepath)
	if err != nil {
		return false, err
	}
	defer f.Close()

	r := transform.NewReader(f, enc.NewDecoder())

	// Read converted UTF-8 from `r` as needed.
	// As an example we'll read line-by-line showing what was read:
	sc := bufio.NewScanner(r)
	for sc.Scan() {
		isExist, err := regexp.Match(str, sc.Bytes())
		if err != nil {
			return isExist, err
		}
		if isExist {
			return isExist, err
		}
	}

	if err = sc.Err(); err != nil {
		return isExist, err
	}

	return isExist, err
}

// Копирует указанный файл в архивную директорию
// src,dst = полный путь включая имя файла
func MakeCopy(src string, dst string) error {
	f, err := os.Open(src)
	if err != nil {
		log.Printf("MakeCopy: Невозможно открыть файл: %v\n", err)
		return err
	}
	defer f.Close()

	if _, err = os.Stat(dst); os.IsExist(err) {
		// Файл существует и не будет перезаписан
		return err
	}

	df, err := os.Create(dst)
	defer df.Close()

	if _, err = io.Copy(df, f); err != nil {
		return err
	}
	if err := df.Sync(); err != nil {
		return err
	}

	return err
}
