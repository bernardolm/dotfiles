SELECTED_EMOJIS=(
    💩
    🐦
    🚀
    🐞
    🎨
    🍕
    🐭
    👽
    ☕️
    🔬
    💀
    🐷
    🐼
    🐶
    🐸
    🐧
    🐳
    🍔
    🍣
    🍻
    🔮
    💰
    💎
    💾
    💜
    🍪
    🌞
    🌍
    🐌
    🐓
    🍄
)

function random_emoji () {
    local index=$(($RANDOM%${#SELECTED_EMOJIS[@]}+1))
    echo -n ${SELECTED_EMOJIS[$index]}
}
