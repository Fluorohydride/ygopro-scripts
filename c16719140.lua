--サブテラーの戦士
function c16719140.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16719140,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16719140)
	e1:SetCost(c16719140.spcost)
	e1:SetTarget(c16719140.sptg1)
	e1:SetOperation(c16719140.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16719140,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16719141)
	e2:SetCondition(c16719140.spcon)
	e2:SetTarget(c16719140.sptg2)
	e2:SetOperation(c16719140.spop2)
	c:RegisterEffect(e2)
end
function c16719140.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c16719140.costfilter(c,e,tp,mg,rlv,mc)
	if not (c:IsLevelAbove(0) and c:IsSetCard(0xed) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)) then return false end
	return mg:CheckSubGroup(c16719140.fselect,1,c:GetLevel(),tp,c:GetLevel()-rlv,mc)
end
function c16719140.fselect(g,tp,lv,mc)
	local mg=g:Clone()
	mg:AddCard(mc)
	if Duel.GetMZoneCount(tp,mg)>0 then
		if lv<=0 then
			return g:GetCount()==1
		else
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetOriginalLevel,lv)
		end
	else return false end
end
function c16719140.relfilter(c)
	return c:IsLevelAbove(1)
end
function c16719140.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetReleaseGroup(tp,false,REASON_EFFECT):Filter(c16719140.relfilter,c)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if not c:IsLevelAbove(1) or not c:IsReleasableByEffect() or mg:GetCount()==0 then return false end
		return Duel.IsExistingMatchingCard(c16719140.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg,c:GetOriginalLevel(),c)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16719140.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg,c:GetOriginalLevel(),c)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16719140.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local mg=Duel.GetReleaseGroup(tp,false,REASON_EFFECT):Filter(c16719140.relfilter,c)
	if mg:GetCount()==0 then return end
	if aux.NecroValleyFilter()(tc) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:SelectSubGroup(tp,c16719140.fselect,false,1,tc:GetLevel(),tp,tc:GetLevel()-c:GetOriginalLevel(),c)
		if g and g:GetCount()>0 then
			g:AddCard(c)
			if Duel.Release(g,REASON_EFFECT)~=0 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)
				if tc:IsFacedown() then
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
	end
end
function c16719140.cfilter(c,tp)
	return c:IsSetCard(0x10ed) and c:IsControler(tp)
end
function c16719140.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16719140.cfilter,1,nil,tp)
end
function c16719140.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16719140.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
