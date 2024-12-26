--クローラー・ソゥマ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+o)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsLevelAbove(0) and c:IsLevelBelow(4) and c:IsSetCard(0x104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function s.gselect(sg,lv)
	return sg:GetSum(Card.GetLevel)==lv
end
function s.gcheck(lv)
	return	function(sg)
				return aux.dncheck(sg) and sg:GetSum(Card.GetLevel)<=lv
			end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local clv=c:GetLevel()
		if clv<=2 then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		aux.GCheckAdditional=s.gcheck(2)
		local b2=clv>2 and g:CheckSubGroup(s.gselect,1,ft,2)
		aux.GCheckAdditional=s.gcheck(4)
		local b4=clv>4 and g:CheckSubGroup(s.gselect,1,ft,4)
		aux.GCheckAdditional=nil
		return b2 or b4
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local clv=c:GetLevel()
	if clv<=2 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	aux.GCheckAdditional=s.gcheck(2)
	local b2=clv>2 and g:CheckSubGroup(s.gselect,1,ft,2)
	aux.GCheckAdditional=s.gcheck(4)
	local b4=clv>4 and g:CheckSubGroup(s.gselect,1,ft,4)
	aux.GCheckAdditional=nil
	local off=1
	local ops={}
	local opval={}
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local lv=opval[Duel.SelectOption(tp,table.unpack(ops))]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-lv)
	c:RegisterEffect(e1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=s.gcheck(lv)
	local sg=g:SelectSubGroup(tp,s.gselect,false,1,ft,lv)
	aux.GCheckAdditional=nil
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_DEFENSE)
end
