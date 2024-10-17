--BF－魔風のボレアース
---@param c Card
function c10602628.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c10602628.mfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10602628,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10602628)
	e1:SetCondition(c10602628.lvcon)
	e1:SetTarget(c10602628.lvtg)
	e1:SetOperation(c10602628.lvop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10602628,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCountLimit(1,10602629)
	e2:SetCondition(aux.bdogcon)
	e2:SetCost(c10602628.spcost)
	e2:SetTarget(c10602628.sptg)
	e2:SetOperation(c10602628.spop)
	c:RegisterEffect(e2)
end
function c10602628.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c10602628.tgfilter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10602628.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c10602628.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c10602628.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10602628.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10602628.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local ec=g:GetFirst()
		if ec:IsLocation(LOCATION_GRAVE) and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(ec:GetLevel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c10602628.spcfilter(c,tp)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and Duel.GetMZoneCount(tp,c)>0
end
function c10602628.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c10602628.spcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,bc,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10602628.spcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,bc,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10602628.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c10602628.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
