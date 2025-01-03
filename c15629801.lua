--武闘円舞
---@param c Card
function c15629801.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c15629801.target)
	e1:SetOperation(c15629801.activate)
	c:RegisterEffect(e1)
end
function c15629801.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15629802,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function c15629801.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c15629801.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c15629801.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c15629801.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c15629801.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,15629802,0,TYPES_TOKEN_MONSTER,tc:GetAttack(),tc:GetDefense(),tc:GetLevel(),tc:GetRace(),tc:GetAttribute()) then return end
	local token=Duel.CreateToken(tp,15629802)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e6:SetValue(1)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	token:RegisterEffect(e7)
	Duel.SpecialSummonComplete()
end
