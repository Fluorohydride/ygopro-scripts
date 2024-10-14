--セリオンズ“デューク”ユール
---@param c Card
function c57111330.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57111330,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,57111330)
	e1:SetTarget(c57111330.sptg)
	e1:SetOperation(c57111330.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c57111330.indcon)
	e2:SetTarget(c57111330.indtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c57111330.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(700)
	e4:SetCondition(c57111330.atkcon)
	c:RegisterEffect(e4)
end
function c57111330.eqfilter(c,tp)
	return (c:IsRace(RACE_PSYCHO) or c:IsSetCard(0x179)) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp)
end
function c57111330.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c57111330.eqfilter(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c57111330.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectTarget(tp,c57111330.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c57111330.spop(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetValue(c57111330.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
end
function c57111330.eqlimit(e,c)
	return e:GetOwner()==c
end
function c57111330.indcfilter(c)
	return c:GetEquipTarget() or c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c57111330.indcon(e)
	return Duel.IsExistingMatchingCard(c57111330.indcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c57111330.indtg(e,c)
	return c:IsSetCard(0x179)
end
function c57111330.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x179) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c57111330.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsSetCard(0x179)
end
