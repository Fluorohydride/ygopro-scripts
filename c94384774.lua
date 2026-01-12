--海老須神鮮まつり
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCode(custom_code)
	e2:SetCondition(s.tkcon)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsAllTypes(TYPE_EFFECT+TYPE_MONSTER) and c:IsFaceup()
end
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil)
end
function s.cfilter(c,g,tp)
	return g:IsContains(c) and c:IsAllTypes(TYPE_EFFECT+TYPE_MONSTER) and c:IsFaceup()
		and Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-c:GetControler())
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and chkc:IsAllTypes(TYPE_EFFECT+TYPE_MONSTER)
		and chkc:IsFaceup() and chkc:IsOnField()
		and Duel.GetLocationCount(1-chkc:GetControler(),LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-chkc:GetControler())
	end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,eg,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToChain() and tc:IsType(TYPE_MONSTER)) then return end
	local sp=tc:GetControler()
	if Duel.GetLocationCount(1-sp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-sp) then return end
	local token=Duel.CreateToken(tp,id+o)
	Duel.SpecialSummon(token,0,tp,1-sp,false,false,POS_FACEUP_DEFENSE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
	g:AddCard(c)
	if chk==0 then return g:GetCount()>0 and Duel.GetMZoneCount(tp,g)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o*2,0,TYPES_TOKEN_MONSTER,-2,-2,7,RACE_FAIRY,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e),TYPE_TOKEN)
	if g:GetCount()==0 then return end
	g:AddCard(c)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if not og:IsContains(c) or og:GetCount()<2
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o*2,0,TYPES_TOKEN_MONSTER,-2,-2,7,RACE_FAIRY,ATTRIBUTE_WATER) then return end
		local atk=og:GetCount()-1
		local token=Duel.CreateToken(tp,id+o*2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(atk*700)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		token:RegisterEffect(e2)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
