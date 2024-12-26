--リチュアの氷魔鏡
---@param c Card
function c36982581.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c36982581.target)
	e1:SetOperation(c36982581.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c36982581.tdtg)
	e2:SetOperation(c36982581.tdop)
	c:RegisterEffect(e2)
end
function c36982581.rfilter1(c,e,tp)
	return c:IsSetCard(0x3a)
end
function c36982581.rfilter2(c,e,tp)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x3a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c36982581.cfilter(c,e,tp)
	return c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsControler(tp)
end
function c36982581.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetReleaseGroup(1-tp,false,REASON_EFFECT):Filter(c36982581.cfilter,nil,e,1-tp)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c36982581.rfilter1,e,tp,mg1,nil,Card.GetLevel,"Equal")
			or (mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c36982581.rfilter2,tp,LOCATION_HAND,0,1,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c36982581.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	::cancel::
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetReleaseGroup(1-tp,false,REASON_EFFECT):Filter(c36982581.cfilter,nil,e,1-tp)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c36982581.rfilter1,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local g2=nil
	local g=g1
	if mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g2=Duel.GetMatchingGroup(c36982581.rfilter2,tp,LOCATION_HAND,0,nil,e,tp)
		g=g1+g2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if g1:IsContains(tc) and (not g2 or (g2:IsContains(tc) and not Duel.SelectYesNo(tp,aux.Stringid(36982581,0)))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			if not mat then goto cancel end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local matc=mg2:SelectUnselect(nil,tp,false,true,1,1)
			if not matc then goto cancel end
			local mat=Group.FromCards(matc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetBaseAttack())
			tc:CompleteProcedure()
		end
	end
end
function c36982581.tdfilter(c)
	return c:IsSetCard(0x3a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c36982581.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c36982581.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c36982581.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c36982581.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c36982581.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
