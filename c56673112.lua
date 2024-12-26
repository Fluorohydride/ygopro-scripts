--インペリアル・バウアー
---@param c Card
function c56673112.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56673112,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,56673112)
	e1:SetCondition(c56673112.spcon)
	e1:SetCost(c56673112.spcost)
	e1:SetTarget(c56673112.sptg)
	e1:SetOperation(c56673112.spop)
	c:RegisterEffect(e1)
end
function c56673112.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c56673112.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c56673112.opfilter(c,e,tp,ft)
	return (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0) and c:IsCode(64788463,25652259,90876561)
end
function c56673112.opcheck(g,e,tp,ft)
	if g:GetClassCount(Card.GetCode)<2 then return false end
	local thct=g:FilterCount(Card.IsAbleToHand,nil)
	local spct=g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	return thct+math.min(spct,ft)>=2
end
function c56673112.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp,e:GetHandler())
		if ft<0 then ft=0 end
		if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c56673112.opfilter,tp,LOCATION_DECK,0,nil,e,tp,ft)
		return g:CheckSubGroup(c56673112.opcheck,2,2,e,tp,ft)
	end
end
function c56673112.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then ft=0 end
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c56673112.opfilter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c56673112.opcheck,false,2,2,e,tp,ft)
	if not sg then return end
	local thsg=Group.CreateGroup()
	local spsg=Group.CreateGroup()
	local thct=sg:FilterCount(Card.IsAbleToHand,nil)
	local spct=sg:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if thct==0 then
		spsg=sg
	elseif spct==0 or ft==0 then
		thsg=sg
	else
		if Duel.SelectYesNo(tp,aux.Stringid(56673112,1)) or ft<2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			thsg=sg:FilterSelect(tp,Card.IsAbleToHand,1,thct,nil)
			spsg=sg-thsg
		else
			spsg=sg
		end
	end
	if #thsg>0 then
		Duel.SendtoHand(thsg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thsg)
	end
	if #spsg>0 then
		Duel.SpecialSummon(spsg,0,tp,tp,false,false,POS_FACEUP)
	end
end
