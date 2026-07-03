--Vortex of Time
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,97077563)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.chtg)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	local check=g:IsExists(Card.IsRace,1,nil,RACE_ZOMBIE) and g:IsExists(Card.IsCode,1,nil,97077563)
	return rp==1-tp and check and
		(re:IsActiveType(TYPE_MONSTER) or re:GetActiveType()==TYPE_SPELL or re:IsActiveType(TYPE_QUICKPLAY))
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil,tp,REASON_RULE)
		or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil,1-tp,REASON_RULE)
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(1-tp,1)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if res==1 then
		Duel.ChangeChainOperation(ev,s.repop1)
	else
		Duel.ChangeChainOperation(ev,s.repop2)
	end
end
function s.repop1(e,tp,eg,ep,ev,re,r,rp)
	local op=1-tp
	Duel.Hint(HINT_SELECTMSG,op,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(op,Card.IsAbleToRemove,op,LOCATION_MZONE,0,1,1,nil,op,REASON_RULE)
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_RULE,op)
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
	local op=tp
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil,op,REASON_RULE)
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
end
