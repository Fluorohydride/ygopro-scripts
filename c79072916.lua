--ミュートリア反射作用
function c79072916.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79072916.target)
	e1:SetOperation(c79072916.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79072916.eqlimit)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79072916,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c79072916.rmcon)
	e3:SetTarget(c79072916.rmtg)
	e3:SetOperation(c79072916.rmop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79072916,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79072916)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c79072916.sptg)
	e4:SetOperation(c79072916.spop)
	c:RegisterEffect(e4)
end
function c79072916.eqlimit(e,c)
	return c:IsSetCard(0x157) and e:GetHandler():IsControler(c:GetControler()) and c:IsLevelAbove(8)
end
function c79072916.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x157) and c:IsLevelAbove(8)
end
function c79072916.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79072916.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79072916.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79072916.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79072916.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c79072916.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec then return false end
	local tc=ec:GetBattleTarget()
	return tc and Duel.GetAttacker()==ec and tc:IsSummonType(SUMMON_TYPE_SPECIAL)
		and tc:IsControler(1-tp)
end
function c79072916.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c79072916.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c79072916.sptgfilter(c,e,tp,attr)
	return c:GetOriginalAttribute()~=attr and c:IsLevel(8) and c:IsSetCard(0x157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79072916.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=e:GetHandler():GetEquipTarget()
		e:SetLabelObject(tc)
		return tc and tc:IsAbleToGrave() and Duel.GetMZoneCount(tp,tc)>0
			and Duel.IsExistingMatchingCard(c79072916.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,tc:GetOriginalAttribute())
	end
	local tc=e:GetLabelObject()
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c79072916.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c79072916.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetOriginalAttribute())
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
