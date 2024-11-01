--暗黒界の隠者 パアル
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and bit.band(r,0x4040)==0x4040
end
function s.spfilter(c,e,tp)
	return not c:IsCode(id)
		and c:IsSetCard(0x6) and c:IsType(TYPE_MONSTER)
		and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	if rp==1-tp and tp==e:GetLabel() then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function s.spfilter2(c,e,tp)
	return c:IsRace(RACE_FIEND)
		and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_GRAVE))
		and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)))
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local res=0
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	else
		return
	end
	if op==0 then
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		res=Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
	if res~=0 and rp==1-tp and tp==e:GetLabel()
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		local tc1=g:GetFirst()
		if tc1 then
			local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc1:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local b4=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc1:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
			local sop=0
			if b3 and b4 then
				sop=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			elseif b3 then
				sop=Duel.SelectOption(tp,aux.Stringid(id,2))
			elseif b4 then
				sop=Duel.SelectOption(tp,aux.Stringid(id,3))+1
			else return end
			if sop==0 then
				Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SpecialSummon(tc1,0,tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
