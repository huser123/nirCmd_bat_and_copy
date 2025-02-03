import os
import shutil
import time

# Alap munkakönyvtár
base_dir = r"\\eleresi\ut"

# Bekéri a felhasználótól, melyik almappát szeretné vizsgálni
subfolder = input("Add meg a mappát (pl. 10b): ").strip()
working_dir = os.path.join(base_dir, subfolder)

# Ellenőrzi, hogy a megadott könyvtár létezik-e
if not os.path.isdir(working_dir):
    print(f"Hiba: A megadott könyvtár nem létezik: {working_dir}")
    exit(1)

# Célkönyvtár a Z: meghajtón
destination_root = r"Z:\kepernyo"
os.makedirs(destination_root, exist_ok=True)  # Ha nem létezik, létrehozza

# Végigmegy az almappákon
for student_folder in os.listdir(working_dir):
    student_path = os.path.join(working_dir, student_folder)

    # Csak akkor folytatja, ha mappa
    if not os.path.isdir(student_path):
        continue

    screenshots_path = os.path.join(student_path, "screenshots")

    # Ha nincs "screenshots" mappa, ugrik a következőre
    if not os.path.isdir(screenshots_path):
        continue

    # Megnézi a screenshots mappa tartalmát
    subfolders = [os.path.join(screenshots_path, f) for f in os.listdir(screenshots_path) if os.path.isdir(os.path.join(screenshots_path, f))]

    if not subfolders:
        # Ha nincs benne almappa, akkor létrehozza a célhelyen üresen
        target_screenshots_path = os.path.join(destination_root, student_folder, "screenshots")
        os.makedirs(target_screenshots_path, exist_ok=True)
        print(f"Üres 'screenshots' mappa átmásolva: {target_screenshots_path}")
        continue

    # Legújabb mappa kiválasztása Unix timestamp alapján
    latest_folder = max(subfolders, key=lambda f: os.path.getctime(f))
    latest_folder_name = os.path.basename(latest_folder)

    # Célkönyvtár létrehozása
    target_path = os.path.join(destination_root, student_folder, "screenshots", latest_folder_name)
    os.makedirs(target_path, exist_ok=True)

    # Másolás
    for item in os.listdir(latest_folder):
        src = os.path.join(latest_folder, item)
        dest = os.path.join(target_path, item)

        if os.path.isdir(src):
            shutil.copytree(src, dest, dirs_exist_ok=True)  # Mappák másolása
        else:
            shutil.copy2(src, dest)  # Fájlok másolása

        print(f"Másolva: {src} -> {dest}")

print("Feldolgozás kész!")
