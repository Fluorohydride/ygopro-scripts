--花札衛－桜－
function c30382214.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c30382214.spcon)
	e1:SetTarget(c30382214.sptg)
	e1:SetOperation(c30382214.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c30382214.drawcost)
	e2:SetTarget(c30382214.drawtg)
	e2:SetOperation(c30382214.drawop)
	c:RegisterEffect(e2)
end
function c30382214.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe6) and c:IsLevelBelow(2)
end
function c30382214.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c30382214.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c30382214.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c30382214.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c30382214.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c30382214.splimit(e,c)
	return not c:IsSetCard(0xe6)
end
function c30382214.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xe6) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xe6)
	Duel.Release(g,REASON_COST)
end
function c30382214.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c30382214.sfilter(c,e,tp)
	return c:IsSetCard(0xe6) and c:IsType(TYPE_MONSTER) and not c:IsCode(30382214)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c30382214.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-p,tc)
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xe6) then
			local sel=1
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(30382214,0))
			if Duel.IsExistingMatchingCard(c30382214.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
				sel=Duel.SelectOption(tp,1213,1214)
			else
				sel=Duel.SelectOption(tp,1214)+1
			end
			if sel==0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sc=Duel.SelectMatchingCard(tp,c30382214.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
					and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				else
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				end
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
