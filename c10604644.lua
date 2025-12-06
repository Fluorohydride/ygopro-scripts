--セリオンズ“キング”レギュラス
local s,id,o=GetID()
function c10604644.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10604644,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10604644)
	e1:SetTarget(c10604644.sptg)
	e1:SetOperation(c10604644.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10604644,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10604644+o)
	e2:SetCondition(c10604644.discon)
	e2:SetCost(c10604644.discost)
	e2:SetTarget(c10604644.distg)
	e2:SetOperation(c10604644.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c10604644.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(700)
	e4:SetCondition(c10604644.atkcon)
	c:RegisterEffect(e4)
end
function c10604644.eqfilter(c,tp)
	return (c:IsRace(RACE_MACHINE) or c:IsSetCard(0x179)) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp)
end
function c10604644.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c10604644.eqfilter(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c10604644.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectTarget(tp,c10604644.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10604644.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Equip(tp,tc,c,false)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c10604644.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
end
function c10604644.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10604644.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c10604644.cfilter(c)
	return c:IsSetCard(0x179) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost()
end
function c10604644.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10604644.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10604644.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10604644.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c10604644.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c10604644.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x179) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c10604644.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsSetCard(0x179)
end
