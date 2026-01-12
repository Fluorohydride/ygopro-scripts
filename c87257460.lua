--魅惑の女王 LV3
local s,id,o=GetID()
function c87257460.initial_effect(c)
	aux.AddCodeList(c,87257460,23756165)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87257460,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c87257460.eqcon1)
	e1:SetTarget(c87257460.eqtg)
	e1:SetOperation(c87257460.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c87257460.eqcon2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87257460,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c87257460.spcon)
	e3:SetCost(c87257460.spcost)
	e3:SetTarget(c87257460.sptg)
	e3:SetOperation(c87257460.spop)
	c:RegisterEffect(e3)
end
c87257460.lvup={23756165}
function c87257460.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not aux.IsSelfEquip(c,FLAG_ID_ALLURE_QUEEN) and not aux.IsCanBeQuickEffect(c,tp,95937545)
end
function c87257460.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not aux.IsSelfEquip(c,FLAG_ID_ALLURE_QUEEN) and aux.IsCanBeQuickEffect(c,tp,95937545)
end
function c87257460.filter(c)
	return c:IsLevelBelow(3) and c:IsFaceup() and c:IsAbleToChangeControler()
end
function c87257460.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c87257460.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c87257460.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c87257460.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c87257460.eqlimit(e,c)
	return e:GetOwner()==c
end
function c87257460.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		--Add Equip limit
		tc:RegisterFlagEffect(FLAG_ID_ALLURE_QUEEN,RESET_EVENT+RESETS_STANDARD,0,0,id)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c87257460.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c87257460.repval)
		tc:RegisterEffect(e2)
	end
end
function c87257460.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c87257460.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and aux.IsSelfEquip(e:GetHandler(),FLAG_ID_ALLURE_QUEEN)
end
function c87257460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c87257460.spfilter(c,e,tp)
	return c:IsCode(23756165) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_LV,tp,true,false)
end
function c87257460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c87257460.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c87257460.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87257460.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
