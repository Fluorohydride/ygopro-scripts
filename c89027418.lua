--Imposter Shift
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(s.tokencost)
	e3:SetTarget(s.tokentg)
	e3:SetOperation(s.tokenop)
	c:RegisterEffect(e3)
end
function s.tfilter(c,rc,ev)
	return c:IsOnField() and c:IsRelateToChain(ev) and not rc:GetColumnGroup():IsContains(c)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local rc=re:GetHandler()
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and rc:IsRelateToChain(ev) and rc:IsControler(rp) and rc:IsType(TYPE_MONSTER)
		and tg and tg:IsExists(s.tfilter,1,rc,rc,ev)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,1,nil,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,1,1,nil,tp)
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT,1-tp)>0 then
			res=true
		end
	end
	if not res then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
	end
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(1) and c:IsFaceupEx()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,800,800,c:GetLevel(),RACE_PSYCHO,ATTRIBUTE_EARTH)
end
function s.tokencost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,c,tp):GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function s.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,800,800,lv,RACE_PSYCHO,ATTRIBUTE_EARTH) then
		local tk=Duel.CreateToken(tp,id+o)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(lv)
		tk:RegisterEffect(e1,true)
		Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
	end
end
