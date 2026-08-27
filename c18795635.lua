--第５５次GMX応用試験
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter1(c)
	return c:IsSetCard(0x1dd) and c:IsType(TYPE_MONSTER)
end
function s.cfilter2(c)
	return c:IsRace(RACE_DINOSAUR)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(
				function(c) return s.cfilter1(c) or s.cfilter2(c) end,
				tp,LOCATION_DECK,0,2,nil
			)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function s.fusfilter(c)
	return c:IsSetCard(0x1dd)
end
function s.fusion_spell_matfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetSequence()>=e:GetLabel()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	local g1=Duel.GetMatchingGroup(s.cfilter1,tp,LOCATION_DECK,0,nil)
	if #g1==0 then return end
	local g2=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_DECK,0,nil)
	if #g2==0 then return end
	-- top card in g1
	local c1=g1:GetMaxGroup(Card.GetSequence):GetFirst()
	-- top card in g2
	local c2=g2:GetMaxGroup(Card.GetSequence):GetFirst()
	local seq=math.min(c1:GetSequence(),c2:GetSequence())
	-- same card: try 2nd top
	if c1==c2 then
		g1:RemoveCard(c1)
		g2:RemoveCard(c2)
		-- if no 2nd cards, just exit
		if #g1==0 and #g2==0 then return end

		local seq1=(#g1>0) and select(2,g1:GetMaxGroup(Card.GetSequence)) or -1
		local seq2=(#g2>0) and select(2,g2:GetMaxGroup(Card.GetSequence)) or -1
		seq=math.max(seq1,seq2)
	end
	local excavate_count=dcount-seq
	Duel.ConfirmDecktop(tp,excavate_count)
	if e:GetHandler():IsSetCard(0x1dd) then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+1595137,e,0,tp,tp,0)
	end
	Duel.SetLP(tp,Duel.GetLP(tp)-excavate_count*400)
	if Duel.GetLP(tp)<=0 then return end
	e:SetLabel(seq)
	local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_DECK,
		fusion_spell_matfilter=s.fusion_spell_matfilter
	})
	if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.ShuffleDeck(tp)
end
