--絶縁の落とし穴
function c56526564.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c56526564.condition)
	e1:SetTarget(c56526564.target)
	e1:SetOperation(c56526564.activate)
	c:RegisterEffect(e1)
	--
	if not Card.IsLinkState then
		function Card.IsLinkState(c)
			if not c then return false end
			if c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()>0 then return true end
			local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
			local lc=g:GetFirst()
			while lc do
				local lg=lc:GetLinkedGroup()
				if lg and lg:IsContains(c) then return true end
				lc=g:GetNext()
			end
			return false
		end
	end
end
function c56526564.cfilter(c)
	return c:IsType(TYPE_LINK) and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c56526564.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c56526564.cfilter,1,nil)
end
function c56526564.filter(c)
	return not c:IsLinkState()
end
function c56526564.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c56526564.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c56526564.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c56526564.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
