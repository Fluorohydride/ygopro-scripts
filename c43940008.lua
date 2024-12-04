--決闘塔アルカトラズ
function c43940008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choose
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43940008,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c43940008.csop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43940008,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c43940008.dop)
	c:RegisterEffect(e3)
end
function c43940008.csfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetTextAttack()>=0 and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c43940008.csop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc1=Duel.SelectMatchingCard(tp,c43940008.csfilter,tp,LOCATION_DECK,0,0,1,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local sc2=Duel.SelectMatchingCard(1-tp,c43940008.csfilter,1-tp,LOCATION_DECK,0,0,1,nil,1-tp):GetFirst()
	if sc1 or sc2 then
		local p=0
		if (not sc2) or sc1 and sc1:GetTextAttack()>sc2:GetTextAttack() then p=tp
		elseif (not sc1) or sc1:GetTextAttack()<sc2:GetTextAttack() then p=1-tp
		else p=PLAYER_ALL end
		if sc1 then Duel.ConfirmCards(1-tp,sc1) end
		if sc2 then Duel.ConfirmCards(tp,sc2) end
		Duel.Remove(Group.FromCards(sc1,sc2),POS_FACEDOWN,REASON_EFFECT)
		if (p==tp or p==PLAYER_ALL) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(43940008,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DIRECT_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
		end
		if (p==1-tp or p==PLAYER_ALL) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,1,nil,e,0,1-tp,false,false)
			and Duel.SelectYesNo(1-tp,aux.Stringid(43940008,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,1,1,nil,e,0,1-tp,false,false):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DIRECT_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2)
			end
		end
	end
end
function c43940008.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnPlayer()==tp and 2 or 1
	c:RegisterFlagEffect(43940008,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(Duel.GetTurnCount()+ct)
	e1:SetCountLimit(1)
	e1:SetCondition(c43940008.descon)
	e1:SetOperation(c43940008.desop)
	Duel.RegisterEffect(e1,tp)
end
function c43940008.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnCount()==e:GetLabel() and c:IsOnField() and c:IsFaceup()
		and c:GetFlagEffect(43940008)>0
end
function c43940008.desop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	Duel.Hint(HINT_CARD,0,43940008)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
