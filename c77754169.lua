--超装甲兵器ロボ ブラックアイアンG
function c77754169.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77754169,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,77754169)
	e1:SetTarget(c77754169.sptg)
	e1:SetOperation(c77754169.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77754169,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,77754170)
	e2:SetCost(c77754169.descost)
	e2:SetTarget(c77754169.destg)
	e2:SetOperation(c77754169.desop)
	c:RegisterEffect(e2)
end
function c77754169.eqfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,2,c,c:GetCode())
end
function c77754169.fselect(g)
	return g:GetClassCount(Card.GetCode)==1
end
function c77754169.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c77754169.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),3)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(c77754169.fselect,1,ft)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,c77754169.fselect,false,1,ft)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77754169.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if ft<g:GetCount() then return end
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			Duel.Equip(tp,tc,c,false,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c77754169.eqlimit)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(77754169,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		Duel.EquipComplete()
	end
end
function c77754169.eqlimit(e,c)
	return e:GetOwner()==c
end
function c77754169.tgfilter(c,tp)
	return c:GetFlagEffect(77754169)~=0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c77754169.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetTextAttack())
end
function c77754169.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)
end
function c77754169.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c77754169.tgfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c77754169.tgfilter,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetTextAttack())
	Duel.SendtoGrave(g,REASON_COST)
end
function c77754169.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77754169.desfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77754169.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77754169.desfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
