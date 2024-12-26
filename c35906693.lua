--シャイニング・ドロー
---@param c Card
function c35906693.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c35906693.regcon)
	e1:SetOperation(c35906693.regop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35906693,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c35906693.condition)
	e2:SetCost(c35906693.cost)
	e2:SetTarget(c35906693.eqtg)
	e2:SetOperation(c35906693.eqop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(35906693,2))
	e3:SetTarget(c35906693.sptg)
	e3:SetOperation(c35906693.spop)
	c:RegisterEffect(e3)
end
function c35906693.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,35906693)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function c35906693.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(35906693,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(35906693,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end
function c35906693.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c35906693.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(35906693)~=0 end
end
function c35906693.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ)
end
function c35906693.eqfilter(c,tp)
	return c:IsSetCard(0x107e) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c35906693.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c35906693.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c35906693.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c35906693.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c35906693.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c35906693.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ft<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.GetMatchingGroup(c35906693.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if not sg then return end
	local ec=sg:GetFirst()
	while ec do
		Duel.Equip(tp,ec,tc,true,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c35906693.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
		ec=sg:GetNext()
	end
	Duel.EquipComplete()
end
function c35906693.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c35906693.filter1(c,e,tp)
	return c35906693.tgfilter(c)
		and Duel.IsExistingMatchingCard(c35906693.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c35906693.filter2(c,e,tp,mc)
	return c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ) and not c:IsCode(mc:GetCode()) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c35906693.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c35906693.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c35906693.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c35906693.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35906693.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35906693.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
